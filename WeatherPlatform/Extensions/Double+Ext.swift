//
//  Double+Ext.swift
//  Domain
//
//  Created by InKwon on 24/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

enum Bearing: Double {
  case N = 0.0
  case NEE = 22.5
  case NE = 45.0
  case ENE = 67.5
  case E = 90
  case ESE = 112.5
  case SE = 135.0
  case SSE = 157.5
  case S = 180.0
  case SSW = 202.5
  case SW = 225.0
  case WSW = 247.5
  case W = 270.0
  case WNW = 292.5
  case NW = 315.0
  case NWW = 337.5
}

extension Bearing {
  var name: String {
    switch self {
    case .N:
      return "N"
    case .NEE:
      return "NEE"
    case .NE:
      return "NE"
    case .ENE:
      return "ENE"
    case .E:
      return "E"
    case .ESE:
      return "ESE"
    case .SE:
      return "SE"
    case .SSE:
      return "SSE"
    case .S:
      return "S"
    case .SSW:
      return "SSW"
    case .SW:
      return "SW"
    case .WSW:
      return "WSW"
    case .W:
      return "W"
    case .WNW:
      return "WNW"
    case .NW:
      return "NW"
    case .NWW:
      return "NWW"
  }
  }
}

extension Double {
  //            N
  //       NWW  |  NEE
  //     NW     |     NE
  //   WNW      |      ENE
  //   W        |        E
  //   WSW      |      ESE
  //     SW     |     SE
  //       SSW  |  SSE
  //            S
  
  func getBearing() -> String {
    let bearingDegree: [Double] = [ 0.0, 22.5, 45.0, 67.5,
                                    90.0, 112.5, 135.0, 157.5,
                                    180.0, 202.5, 225.0, 247.5,
                                    270.0, 292.5, 315.0, 337.5 ]
    
    let distances = bearingDegree.map { abs(self - $0) }
    let index = distances.firstIndex(of: distances.min()!)!
    
    return Bearing.init(rawValue: bearingDegree[index])!.name
  }
}
