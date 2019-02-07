//
//  File.swift
//  Domain
//
//  Created by InKwon on 23/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public struct Weather: Codable {
  public let timezone: TimeZone
  public let currently: Currently
  public let hourly: Hourly
  public let daily: Daily
  public let geo: Location
  
  public var icon: String {
    return currently.icon
  }
  
  public var time: String {
    return currently.time
  }
  
  public var sunriseTime: String {
    return daily.data[0].sunriseTime
  }
  
  public var sunsetTime: String {
    return daily.data[0].sunsetTime
  }
  
  public var aqi: Int = 0
  
  public var address: String = ""
  
  public init(timezone: TimeZone,
              currently: Currently,
              hourly: Hourly,
              daily: Daily,
              geo: Location,
              aqi: Int,
              address: String){
    self.timezone = timezone
    self.currently = currently
    self.hourly = hourly
    self.daily = daily
    self.geo = geo
    self.aqi = aqi
    
    let splited = self.timezone.identifier.split(separator: "/")
    self.address = String(splited[splited.count - 1])
  }
  
  private enum CodingKeys: String, CodingKey {
    case currently
    case hourly
    case daily
    case timezone
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let timezone = try container.decode(String.self, forKey: .timezone)
    self.timezone = TimeZone(identifier: timezone)!
    
    geo = try Location(from: decoder)
    currently = try container.decode(Currently.self, forKey: .currently)
    hourly = try container.decode(Hourly.self, forKey: .hourly)
    daily = try container.decode(Daily.self, forKey: .daily)
    
  }
}
