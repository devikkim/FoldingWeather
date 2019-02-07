//
//  Weather+Ext.swift
//  WeatherPlatform
//
//  Created by InKwon on 30/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Domain

extension Weather {
  //FIXME: address 얻어오는 부분 수정
  public func formatted() -> Weather {
    
    // formatting Currently
    var currently = self.currently
    currently.time = Int(self.currently.time)!
      .toFormattedDateFromTimestamp(dateFormat: "HH", timeZone: self.timezone)
    
    currently.windBearing = Double(self.currently.windBearing)!.getBearing()
    
    // formatting Daily.Data
    let dailyData = self.daily.data.map { element -> Daily.Data in
      var data = element
      data.time = Int(element.time)!.toFormattedDateFromTimestamp(dateFormat: "eee",
                                                                  timeZone: self.timezone)
      data.sunsetTime = Int(element.sunsetTime)!.toFormattedDateFromTimestamp(dateFormat: "HH:mm",
                                                                              timeZone: self.timezone)
      data.sunriseTime = Int(element.sunriseTime)!.toFormattedDateFromTimestamp(dateFormat: "HH:mm",
                                                                                timeZone: self.timezone)
      return data
    }
    
    let daily = Daily(data: dailyData)
    
    // formatting Houly.Data
    let hourlyData = self.hourly.data.map { element -> Hourly.Data in
      var data = element
      data.time = Int(element.time)!.toFormattedDateFromTimestamp(dateFormat: "HH",
                                                                  timeZone: self.timezone)
      return data
    }
    let hourly = Hourly(data: hourlyData)
    
    return Weather(timezone: self.timezone,
                   currently: currently,
                   hourly: hourly,
                   daily: daily,
                   geo: self.geo,
                   aqi: self.aqi,
                   address: self.address)
  }
}

