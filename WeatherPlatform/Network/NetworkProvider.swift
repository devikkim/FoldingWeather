//
//  NetworkProvider.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Domain

public enum DegreeUnit: String {
  case si
  case us
}

final class NetworkProvider {
  private let weatherApiUrl: String
  private let airApiUrl: String
  private let unit: DegreeUnit
  
  init(weatherApiKey: String,
       airApiKey: String,
       unit: DegreeUnit = .si) {
    self.unit = unit
    
    weatherApiUrl = "https://api.darksky.net/forecast/\(weatherApiKey)" +
      "/latitude,longitude?" +
      "units=\(self.unit.rawValue)" +
    "&lang=\(Language.systemCode)"
    
    airApiUrl = ("https://api.waqi.info/feed/" +
      "geo:latitude; longitude/?" +
      "token=\(airApiKey)").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
  }
  
  public func makeWeatherProvider() -> WeatherNetwork {
    let network = Network(weatherEndPoint: weatherApiUrl,
                          airEndPoint: airApiUrl)
    
    return WeatherNetwork(network: network)
  }
  
}
