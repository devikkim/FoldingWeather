//
//  HourlyWeatherModel.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation

struct HourlyWeather{
  let time: String
  let icon: IconCase
  let temperature: String
  let precipProbability: String
  
  init(){
    time = ""
    icon = .nil
    temperature = ""
    precipProbability = ""
  }
  
  init(time: String, icon: IconCase, temperature: String, precipProbability: String){
    self.time = time
    self.icon = icon
    self.temperature = temperature
    self.precipProbability = precipProbability
  }
}
