//
//  DomainConvertible.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

/// Realm Object Type -> Domain Type
protocol DomainConvertibleType {
  associatedtype DomainType
  
  func asDomain() -> DomainType
}
