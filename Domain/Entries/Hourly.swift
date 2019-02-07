//
//  Hourly.swift
//  Domain
//
//  Created by InKwon on 23/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public struct Hourly: Codable {
  public let data: [Data]
  
  public init(data: [Data]) {
    self.data = data
  }
    
  public struct Data: Codable {
    public let icon: String
    public let temperature: String
    public let precipProbability: String
    
    public var time: String
    
    private enum CodingKeys: String, CodingKey {
      case icon
      case time
      case temperature
      case precipProbability
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      
      icon = try container.decode(String.self, forKey: .icon)
      
      if let time = try container.decodeIfPresent(Int.self, forKey: .time){
        self.time = "\(time)"
      } else {
        self.time = try container.decodeIfPresent(String.self, forKey: .time) ?? ""
      }
      
      if let temperature = try container.decodeIfPresent(Double.self, forKey: .temperature){
        self.temperature = "\(Int(round(temperature)))˚"
      } else {
        self.temperature = try container.decodeIfPresent(String.self, forKey: .temperature) ?? ""
      }
      
      if let precipProbability = try container.decodeIfPresent(Double.self, forKey: .precipProbability){
        self.precipProbability = "\(Int(precipProbability * 100))%"
      } else {
        self.precipProbability = try container.decodeIfPresent(String.self, forKey: .precipProbability) ?? ""
      }
    }
  }
}

extension Hourly: Equatable {
  public static func == (lhs: Hourly, rhs: Hourly) -> Bool {
    return lhs.data.elementsEqual(rhs.data){ $0 == $1 }
  }
}

extension Hourly.Data: Equatable {
  public static func == (lhs: Hourly.Data, rhs: Hourly.Data) -> Bool {
    return lhs.icon == rhs.icon &&
      lhs.precipProbability == rhs.precipProbability &&
      lhs.temperature == rhs.temperature &&
      lhs.time == rhs.time
  }
}

