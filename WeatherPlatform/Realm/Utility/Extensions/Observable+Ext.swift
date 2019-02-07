//
//  Observable+Ext.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: Sequence, Element.Iterator.Element: DomainConvertibleType {
  typealias DomainType = Element.Iterator.Element.DomainType
  
  func mapToDomain() -> Observable<[DomainType]> {
    return map { sequence -> [DomainType] in
      return sequence.mapToDomain()
    }
  }
}

extension Sequence where Iterator.Element: DomainConvertibleType {
  typealias Element = Iterator.Element
  
  func mapToDomain() -> [Element.DomainType] {
    return map{ $0.asDomain() }
  }
}
