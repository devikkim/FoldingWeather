//
//  RMLocation.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Domain
import RealmSwift
import Realm

final class RMLocation: Object {
  @objc dynamic var id: String = ""
  @objc dynamic var latitude: Double = 0
  @objc dynamic var longitude: Double = 0
  
  override static func primaryKey() -> String? {
    return "id"
  }
}


extension RMLocation: DomainConvertibleType {
  
  func asDomain() -> Location {
    return Location(id: id,
                    latitude: latitude,
                    longitude: longitude)
  }
}

extension Location: RealmRepresentable {
  func asRealm() -> RMLocation {
    return RMLocation.build{ object in
      object.id = id
      object.latitude = latitude
      object.longitude = longitude
    }
  }
}
