//
//  File.swift
//  FoldingWeather
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class RealmCoordinateManager {
  static let shared = RealmCoordinateManager()
  
  func select() -> [Coordinate] {
    var coordinates = [Coordinate]()
    
    do {
      let realm = try Realm()
      
      if let list = realm.objects(Coordinates.self).first {
        coordinates.append(contentsOf: Array(list.items))
      }
    } catch {
      debugPrint("[Realm] Select Error: \(error)")
    }
    return coordinates
  }
  
  func insert(_ coordinate: Coordinate) {
    do {
      let realm = try Realm()
      
      if realm.objects(Coordinates.self).isEmpty {
        let list = Coordinates()
        list.items.append(coordinate)
        try! realm.write {
          realm.add(list)
        }
      } else {
        try realm.write {
          if let list = realm.objects(Coordinates.self).first{
            list.items.append(coordinate)
          }
        }
      }
      
    } catch  {
      debugPrint("[Realm] Insert Error: \(error)")
    }
  }
  
  func delete(_ index: Int) {
    do{
      let realm = try Realm()
      
      try realm.write {
        let list = realm.objects(Coordinates.self).first?.items
        list?.remove(at: index)
      }
    } catch {
      debugPrint("[Realm] Delete Error: \(error)")
    }
  }
}

class RealmDegreeManager {
  static let shared = RealmDegreeManager()
  
  func update(_ unit: Int) {
    do{
      let realm = try Realm()
      
      let list = realm.objects(Degree.self)
      
      if list.isEmpty {
        try realm.write {
          let degree = Degree()
          degree.unit = unit
          realm.add(degree)
        }
      } else {
        if let degree = list.first {
          try realm.write {
            degree.unit = unit
          }
        }
      }
    } catch{
      print("\(error)")
    }
  }
  
  func select() -> Int{
    do{
      let realm = try Realm()
      let list = realm.objects(Degree.self)
      if !list.isEmpty, let degree = list.first {
        return degree.unit
      }
    } catch{
      print("\(error)")
    }
    return 0
  }
}
