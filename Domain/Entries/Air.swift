//
//  Air.swift
//  Domain
//
//  Created by InKwon on 24/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public struct Air: Codable {
  public let data: _Data
  
  public init (aqi: Int, location: Location) {
    self.data = _Data(aqi: aqi)
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    data = try container.decode(_Data.self, forKey: .data)
  }
  
  public struct _Data: Codable {
    public let aqi: Int
    
    public init(aqi: Int) {
      self.aqi = aqi
    }
    
    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.aqi = try container.decode(Int.self, forKey: .aqi)
    }
  }
}

extension Air._Data: Equatable {
  public static func == (lhs: Air._Data, rhs: Air._Data) -> Bool {
    return lhs.aqi == rhs.aqi
  }
}

extension Air: Equatable {
  public static func == (lhs: Air, rhs: Air) -> Bool {
    return lhs.data == rhs.data
  }
}
