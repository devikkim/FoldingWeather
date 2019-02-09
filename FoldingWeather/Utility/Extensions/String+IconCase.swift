//
//  String+IconType.swift
//  FoldingWeather
//
//  Created by InKwon on 28/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation

extension String {
  func toIcon() -> IconCase? {
    switch self {
    case "clear-day":
      return IconCase.clearDay
      
    case "clear-night":
      return IconCase.clearNight
      
    case "rain":
      return IconCase.rain
      
    case "snow":
      return IconCase.snow
      
    case "sleet":
      return IconCase.sleet
      
    case "wind":
      return IconCase.wind
      
    case "fog":
      return IconCase.fog
      
    case "cloudy":
      return IconCase.cloudy
      
    case "partly-cloudy-day":
      return IconCase.partlyCloudyDay
      
    case"partly-cloudy-night":
      return IconCase.partlyCloudyNight
      
    default:
      return nil
    }
  }
}
