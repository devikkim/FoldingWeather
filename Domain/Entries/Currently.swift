//
//  CurrentlyWeather.swift
//  Domain
//
//  Created by InKwon on 23/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public struct Currently: Codable {
  public let icon: String
  public let summary: String
  public let temperature: String
  public let apparentTemperature: String
  public let pressure: String
  public let humidity: String
  public let precipIntensity: String
  public let precipProbability: String
  public let windSpeed: String
  public let visibility: String
  
  public var windBearing: String
  public var time: String
  
  //apparentTemperature : 체감온도
  //pressure : 기압  hPa
  //humidity: 습도 * 100 %
  //precipIntensity: 강수량 mm/h
  //precipProbability: 강수/눈 확률 * 100 %
  //windSpeed: 바람세기 m/s
  //windBearing: 바람이 부는쪽 0은 북쪽 시계방향으로
  //visibility: 가시거리 km
    
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    icon = try container.decode(String.self, forKey: .icon)
    summary = try container.decode(String.self, forKey: .summary)
    
    if let time = try container.decodeIfPresent(Int.self, forKey: .time) {
      self.time = "\(time)"
    } else {
      self.time = try container.decodeIfPresent(String.self, forKey: .time) ?? ""
    }
    
    if let temperature = try container.decodeIfPresent(Double.self, forKey: .temperature) {
      self.temperature = "\(Int(round(temperature)))˚"
    } else {
      self.temperature = try container.decodeIfPresent(String.self, forKey: .temperature) ?? ""
    }
    
    if let apparentTemperature = try container.decodeIfPresent(Double.self, forKey: .apparentTemperature) {
      self.apparentTemperature = "\(Int(round(apparentTemperature)))˚"
    } else {
      apparentTemperature = try container.decodeIfPresent(String.self, forKey: .apparentTemperature) ?? ""
    }
    
    if let pressure = try container.decodeIfPresent(Double.self, forKey: .pressure) {
      self.pressure = "\(Int(round(pressure)))hPa"
    } else {
      pressure = try container.decodeIfPresent(String.self, forKey: .pressure) ?? ""
    }
    
    if let humidity = try container.decodeIfPresent(Double.self, forKey: .humidity) {
      self.humidity = "\(Int(humidity) * 100)%"
    } else {
      humidity = try container.decodeIfPresent(String.self, forKey: .humidity) ?? ""
    }
    
    if let precipIntensity = try container.decodeIfPresent(Double.self, forKey: .precipIntensity) {
      self.precipIntensity = "\(Int(precipIntensity) * 100)mm/h"
    } else {
      precipIntensity = try container.decodeIfPresent(String.self, forKey: .precipIntensity) ?? ""
    }
    
    if let precipProbability = try container.decodeIfPresent(Double.self, forKey: .precipProbability) {
      self.precipProbability = "\(Int(round(precipProbability)) * 100)%"
    } else {
      precipProbability = try container.decodeIfPresent(String.self, forKey: .precipProbability) ?? ""
    }
    
    if let windSpeed = try container.decodeIfPresent(Double.self, forKey: .windSpeed) {
      self.windSpeed = "\(windSpeed)m/s"
    } else {
      windSpeed = try container.decodeIfPresent(String.self, forKey: .windSpeed) ?? ""
    }
    
    if let windBearing = try container.decodeIfPresent(Double.self, forKey: .windBearing) {
      self.windBearing = "\(windBearing)"
    } else {
      windBearing = try container.decodeIfPresent(String.self, forKey: .windBearing) ?? ""
    }
    
    if let visibility = try container.decodeIfPresent(Double.self, forKey: .visibility) {
      self.visibility = "\(visibility)km"
    } else {
      visibility = try container.decodeIfPresent(String.self, forKey: .visibility) ?? ""
    }
  }
}

extension Currently: Equatable {
  public static func == (lhs: Currently, rhs: Currently) -> Bool {
    return lhs.icon == rhs.icon &&
      lhs.time == rhs.time &&
      lhs.summary == rhs.summary &&
      lhs.temperature == rhs.temperature &&
      lhs.apparentTemperature == rhs.apparentTemperature &&
      lhs.pressure == rhs.pressure &&
      lhs.humidity == rhs.humidity &&
      lhs.precipIntensity == rhs.precipIntensity &&
      lhs.precipProbability == rhs.precipProbability &&
      lhs.windSpeed == rhs.windSpeed &&
      lhs.windBearing == rhs.windBearing &&
      lhs.visibility == rhs.visibility
  }
}
