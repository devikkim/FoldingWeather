//
//  Network.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Alamofire
import Domain
import RxAlamofire
import RxSwift


final class Network {
  private let scheduler: ConcurrentDispatchQueueScheduler
  private let weatherEndPoint: String
  private let airEndPoint: String
  
  init(weatherEndPoint: String,
       airEndPoint: String) {
    self.weatherEndPoint = weatherEndPoint
    self.airEndPoint = airEndPoint
    
    self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
  }

  //FIXME: convert Observable to Single, because result is one of success or error
  func getItems(_ location: Location) -> Observable<Weather> {
    let weatherPath = makeAbsolutPath(weatherEndPoint,
                                      location)
    
    let airPath = makeAbsolutPath(airEndPoint,
                                  location)
    
    return Observable.combineLatest(
      RxAlamofire
        .data(.get, weatherPath)
        .debug()
        .observeOn(scheduler)
        .map { return try JSONDecoder().decode(Weather.self, from: $0) },
      RxAlamofire
        .data(.get, airPath)
        .debug()
        .observeOn(scheduler)
        .map { return try JSONDecoder().decode(Air.self, from: $0) })
      .map { weather, air -> Weather in
        var newWeather = weather.formatted()
        newWeather.aqi = air.data.aqi
        
        return newWeather
      }
  }
  
  private func makeAbsolutPath(_ url: String, _ location: Location) -> String {
    let absolutPath = url
      .replacingOccurrences(of: "latitude",
                            with: "\(location.latitude)")
      .replacingOccurrences(of: "longitude",
                            with: "\(location.longitude)")
    
    return absolutPath
  }
}
