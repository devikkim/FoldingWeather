//
//  DailyWeatherModel.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation

struct DailyWeather{
  let day: String
  let icon: IconCase
  let temperatureMax: String
  let temperatureMin: String
  let sunriseTime: String
  let sunsetTime: String
  
  init(){
    day = ""
    icon = .nil
    
    temperatureMax = ""
    temperatureMin = ""
    
    sunsetTime = ""
    sunriseTime = ""
  }
  
  init(day: String,
       icon: IconCase,
       temperatureMax: String,
       temperatureMin: String,
       sunriseTime: String,
       sunsetTime: String){
    self.day = day
    self.icon = icon
    
    self.temperatureMax = temperatureMax
    self.temperatureMin = temperatureMin
    
    self.sunsetTime = sunsetTime
    self.sunriseTime = sunriseTime
  }
}
