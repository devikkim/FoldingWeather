//
//  Location.swift
//  FoldingWeather
//
//  Created by InKwon on 23/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public struct Location: Codable {
  public let id: String
  public let latitude: Double
  public let longitude: Double
  
  public init(id: String,
              latitude: Double,
              longitude: Double) {
    self.id = id
    self.latitude = latitude
    self.longitude = longitude
  }
  
  public init(latitude: Double,
              longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
    self.id = "\(latitude)&\(longitude)"
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    if let latitude = try container.decodeIfPresent(Double.self, forKey: .latitude),
      let longitude = try container.decodeIfPresent(Double.self, forKey: .longitude){
      self.latitude = latitude
      self.longitude = longitude
    } else {
      let latitude = try container.decodeIfPresent(String.self, forKey: .latitude)
      let longitude = try container.decodeIfPresent(String.self, forKey: .longitude)
      
      self.latitude = Double(latitude!)!
      self.longitude = Double(longitude!)!
    }
    
    self.id = "\(latitude)&\(longitude)"
  }
}

extension Location: Equatable {
  public static func == (lhs: Location, rhs: Location) -> Bool {
    return lhs.longitude == rhs.longitude &&
      lhs.latitude == rhs.latitude &&
      lhs.id == rhs.id
  }
}
