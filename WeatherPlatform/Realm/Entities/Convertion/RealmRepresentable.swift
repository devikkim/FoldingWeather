//
//  RealmRepresentable.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

/// Domain Type -> Realm Object Type
protocol RealmRepresentable{
  associatedtype RealmType: DomainConvertibleType
  
  /// To search realm object for delete
  var id: String {get}
  
  func asRealm() -> RealmType
}
