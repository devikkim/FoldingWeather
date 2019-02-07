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


extension Location {
  public func getAddress() -> Observable<String> {
    
    return Observable.create{ observer in
      let location = CLLocation(latitude: self.latitude , longitude: self.longitude)
      let geocoder = CLGeocoder()
      
      geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
        if (error != nil) {
          return
        }
        
        if let address: [CLPlacemark] = placemarks {
          if let locationString = (address.last?.locality != nil) ? address.last?.locality : address.last?.country {
            observer.onNext(locationString)
            observer.onCompleted()
          }
        }
        
        observer.onNext("unknown")
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}

