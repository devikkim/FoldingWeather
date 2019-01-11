//
//  Parse.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class WeatherJSONParser{
  private var timeFormatter = DateFormatter()
  private var dayFormatter = DateFormatter()
  
  init(_ timeZone: TimeZone) {
    timeFormatter.timeZone = timeZone
    timeFormatter.dateFormat = "HH"
    
    dayFormatter.timeZone = timeZone
    dayFormatter.dateFormat = "eee"
  }
  
  func getCurrentlyWeatherFrom(_ json: JSON, location: String) -> CurrentlyWeather? {
    let currentObj = json["currently"]
    
    guard
      let summary = currentObj["summary"].string,
      let temperature = currentObj["temperature"].double,
      let icon = currentObj["icon"].string?.toIcon(),
      let time = currentObj["time"].int
      else {
        return nil
    }
    
    let date = Date(timeIntervalSince1970: TimeInterval(time))
    let timeString = timeFormatter.string(from: date)
    
    let currentlyModel = CurrentlyWeather(icon : icon,
                                          time: timeString,
                                          location: location,
                                          summary: summary,
                                          temperature: "\(Int(round(temperature)))˚")
    
    return currentlyModel
  }
  
  func getHourlyWeathersFrom(_ json: JSON) -> [HourlyWeather]? {
    guard let hourlyObj = json["hourly"]["data"].array else {
      return nil
    }
    
    return Array(hourlyObj[1..<24]).compactMap{ element -> HourlyWeather in
      guard
        let time = element["time"].int,
        let icon = element["icon"].string?.toIcon(),
        let temperature = element["temperature"].double,
        let precipProbability = element["precipProbability"].double else {
          return HourlyWeather()
      }
      
      let date = Date(timeIntervalSince1970: TimeInterval(time))
      let model = HourlyWeather(time: timeFormatter.string(from: date),
                                icon: icon,
                                temperature: "\(Int(round(temperature)))˚",
                                precipProbability: "\(Int(precipProbability * 100 ))%")
      
      return model
    }
    
  }
  
  func getDailyWeathersFrom(_ json: JSON) -> [DailyWeather]? {
    guard let dailyObj = json["daily"]["data"].array else {
      return nil
    }
    
    return dailyObj.enumerated().compactMap{ (index, element) -> DailyWeather in
      
      guard
        let time = element["time"].int,
        let max = element["temperatureMax"].double,
        let min = element["temperatureMin"].double,
        let icon = element["icon"].string?.toIcon(),
        let sunsetTime = element["sunsetTime"].int,
        let sunriseTime = element["sunriseTime"].int
        else {
          return DailyWeather()
      }
      
      let date = Date(timeIntervalSince1970: TimeInterval(time))
      let sunriseDate = Date(timeIntervalSince1970: TimeInterval(sunriseTime))
      let sunsetDate = Date(timeIntervalSince1970: TimeInterval(sunsetTime))
      let dateString = index == 0 ? "Today" : dayFormatter.string(from: date)
      let sunriseString = timeFormatter.string(from: sunriseDate)
      let sunsetString = timeFormatter.string(from: sunsetDate)
      
      let model = DailyWeather(day: dateString,
                               icon: icon,
                               temperatureMax: "\(Int(round(max)))˚",
                               temperatureMin: "\(Int(round(min)))˚",
                               sunriseTime: sunriseString,
                               sunsetTime: sunsetString)
      return model
    }
  }
}
