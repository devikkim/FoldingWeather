//
//  Location.swift
//  FoldingWeather
//
//  Created by InKwon on 27/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

enum LocationCaseError: Error{
  case doNotGetUserLocation
}

enum LocationCase {
  case user
  case search(_ location: CLLocation)
}

extension LocationCase {
  
  func getWeather(_ unit: Int) -> Observable<Weather> {
    switch self {
    case .user:
      let locationManager = CLLocationManager()
      locationManager.requestWhenInUseAuthorization()
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
      
      guard let location = locationManager.location else {
        return Observable.empty()
      }
      
      let service = WeatherService(unit)
      
      service.setUserSecretKey("0c28aa7763d8751cefdae9b8e6e89a97")
      
      return service.getWeatherFrom(location: location, type: self)
      
    case .search(let location):
      
      let service = WeatherService(unit)
      
      service.setUserSecretKey("0c28aa7763d8751cefdae9b8e6e89a97")
      
      return service.getWeatherFrom(location: location, type: self)
    }
  }
  
  var location: CLLocation? {
    switch self {
    case .user:
      let locationManager = CLLocationManager()
      locationManager.requestWhenInUseAuthorization()
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
      
      guard let location = locationManager.location else {
        return nil
      }
      return location
    case .search(let location):
      return location
    }
  }
}

extension LocationCase: Equatable {
  static func ==(lhs: LocationCase, rhs: LocationCase) -> Bool {
    switch (lhs, rhs) {
    case (.user, .user): return true
    case let(.search(l), .search(r)):
      return l.coordinate.latitude == r.coordinate.latitude &&
        l.coordinate.longitude == r.coordinate.longitude
      
    default:
      return false
    }
  }
}
