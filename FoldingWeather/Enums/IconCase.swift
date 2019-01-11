//
//  IconType.swift
//  FoldingWeather
//
//  Created by InKwon on 28/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation
import UIKit

enum IconCase {
  case clearDay
  case clearNight
  case rain
  case snow
  case sleet
  case wind
  case fog
  case cloudy
  case partlyCloudyDay
  case partlyCloudyNight
  case `nil`
}


extension IconCase {
  var emoji: String {
    switch self {
    case .clearDay:
      return "☀️"
    case .clearNight:
      return "🌙"
    case .rain:
      return "🌧"
    case .snow, .sleet:
      return "❄️"
    case .wind:
      return "💨"
    case .fog:
      return "🌁"
    case .cloudy, .partlyCloudyNight:
      return "☁️"
    case .partlyCloudyDay:
      return "⛅"
    case .nil:
      return ""
    }
  }
}

