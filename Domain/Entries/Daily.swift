//
//  Daily.swift
//  Domain
//
//  Created by InKwon on 23/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public struct Daily: Codable {
  public let data: [Data]
  
  public init(data: [Data]) {
    self.data = data
  }
  
  public struct Data: Codable {
    public let icon: String
    
    public let temperatureMax: String
    public let temperatureMin: String
    
    public var time: String
    public var sunriseTime: String
    public var sunsetTime: String
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      icon = try container.decode(String.self, forKey: .icon)
      
      if let time = try container.decodeIfPresent(Int.self, forKey: .time) {
        self.time = "\(time)"
      } else {
        self.time = try container.decodeIfPresent(String.self, forKey: .time) ?? ""
      }
      
      if let temperatureMax = try container.decodeIfPresent(Double.self, forKey: .temperatureMax) {
        self.temperatureMax = "\(Int(round(temperatureMax)))˚"
      } else {
        self.temperatureMax = try container.decodeIfPresent(String.self, forKey: .temperatureMax) ?? ""
      }
      
      if let temperatureMin = try container.decodeIfPresent(Double.self, forKey: .temperatureMin) {
        self.temperatureMin = "\(Int(round(temperatureMin)))˚"
      } else {
        self.temperatureMin = try container.decodeIfPresent(String.self, forKey: .temperatureMin) ?? ""
      }
      
      if let sunsetTime = try container.decodeIfPresent(Int.self, forKey: .sunsetTime) {
        self.sunsetTime = "\(sunsetTime)"
      } else {
        self.sunsetTime = try container.decodeIfPresent(String.self, forKey: .sunsetTime) ?? ""
      }
      
      if let sunriseTime = try container.decodeIfPresent(Int.self, forKey: .sunriseTime) {
        self.sunriseTime = "\(sunriseTime)"
      } else {
        self.sunriseTime = try container.decodeIfPresent(String.self, forKey: .sunriseTime) ?? ""
      }
    }
  }
}

extension Daily: Equatable {
  public static func == (lhs: Daily, rhs:Daily) -> Bool {
    return lhs.data.elementsEqual(rhs.data){ $0 == $1 }
    
  }
}

extension Daily.Data: Equatable {
  public static func == (lhs: Daily.Data, rhs: Daily.Data) -> Bool {
    return lhs.icon == rhs.icon &&
      lhs.sunsetTime == rhs.sunsetTime &&
      lhs.sunriseTime == rhs.sunsetTime &&
      lhs.temperatureMax == rhs.temperatureMax &&
      lhs.temperatureMin == rhs.temperatureMin &&
      lhs.time == rhs.time
  }
}
