//
//  Location+Ext.swift
//  WeatherPlatform
//
//  Created by InKwon on 30/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import CoreLocation
import Domain
import RxSwift

enum NewLocationError: Error {
  case didNotGetAddress
}

extension Location {
  public func getAddress() -> Single<String> {
    
    return Single<String>.create{ single in
      let location = CLLocation(latitude: self.latitude , longitude: self.longitude)
      let geocoder = CLGeocoder()
      
      geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
        if (error != nil) {
          single(.error(NewLocationError.didNotGetAddress))
          return
        }
        
        if let address: [CLPlacemark] = placemarks {
          if let locationString = (address.last?.locality != nil) ? address.last?.locality : address.last?.country {
            single(.success(locationString))
          }
        }
        
        single(.error(NewLocationError.didNotGetAddress))
      }
      return Disposables.create()
    }
  }
}

