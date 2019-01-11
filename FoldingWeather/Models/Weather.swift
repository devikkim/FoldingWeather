//
//  WeatherViewModel.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation
import RxDataSources

struct Weather {
  let currentlyWeather: CurrentlyWeather
  let hourlyWeathers: [HourlyWeather]
  let dailyWeathers: [DailyWeather]
  
  var icon: IconCase {
    return currentlyWeather.icon
  }
  
  var sunriseTime: String {
    return dailyWeathers[0].sunriseTime
  }
  
  var sunsetTime: String {
    return dailyWeathers[0].sunsetTime
  }
  
  let locationType: LocationCase
  
  let latitude: Double
  let longitude: Double
}
