//
//  WeatherNetwork.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Domain
import RxSwift
import CoreLocation

enum LocationError: Error {
  case userlocation
}

public final class WeatherNetwork {
  private let network: Network
  
  init(network: Network){
    self.network = network
  }
  
  public func fetchWeather(location: Location) -> Observable<Weather> {
    return network.getItems(location)
  }
  
  //FIXME: To fix error when don't fetched use location.
  public func fetchWeather() -> Observable<Weather> {
    let locationManager = CLLocationManager()
    
    locationManager.requestWhenInUseAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()

    guard let location = locationManager.location
      else {
        return Observable.error(LocationError.userlocation)
    }
    
    return fetchWeather(location: Location(latitude: location.coordinate.latitude,
                                           longitude: location.coordinate.longitude))
    
  }
}
