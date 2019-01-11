//
//  RealmTests.swift
//  FoldingWeatherTests
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import XCTest
import RealmSwift
@testable import FoldingWeather

class RealmTests: XCTestCase {
  
  func testRealmInsert(){
    let realm = try! Realm()
    
    try! realm.write {
      realm.deleteAll()
    }
    
    let list = realm.objects(Coordinate.self)
    
    XCTAssert(list.count == 0)
    
    let coord = Coordinate()
    coord.latitude = 37.8267
    coord.longitude = -122.4233
    
    try! realm.write {
      realm.add(coord)
    }
    
    XCTAssert(list.count == 1)
  }
  
  func testDegreeUpdate(){
    
    let realm = try! Realm()
    
    try! realm.write {
      realm.deleteAll()
    }
//    
//    let list = realm.objects(Degree.self)
//    
//    if list.isEmpty {
//      try! realm.write {
//        let unit = Degree()
//        unit.unit = 0
//        realm.add(unit)
//      }
//    } else {
//      if let unit = list.first {
//        try! realm.write {
//          unit.unit = 1
//        }
//      }
//    }
//    print("\(list.first?.unit)")
  }
  
}
