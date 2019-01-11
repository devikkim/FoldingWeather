//
//  String+DeviceCase.swift
//  FoldingWeather
//
//  Created by InKwon on 08/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

extension String {
  func toDevice() -> DeviceCase? {
    switch self {
    case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone4
    case "iPhone4,1":                               return .iPhone4s
    case "iPhone5,1", "iPhone5,2":                  return .iPhone5
    case "iPhone5,3", "iPhone5,4":                  return .iPhone5c
    case "iPhone6,1", "iPhone6,2":                  return .iPhone5s
    case "iPhone7,2":                               return .iPhone6
    case "iPhone7,1":                               return .iPhone6Plus
    case "iPhone8,1":                               return .iPhone6s
    case "iPhone8,2":                               return .iPhone6sPlus
    case "iPhone9,1", "iPhone9,3":                  return .iPhone7
    case "iPhone9,2", "iPhone9,4":                  return .iPhone7Plus
    case "iPhone8,4":                               return .iPhoneSE
    case "iPhone10,1", "iPhone10,4":                return .iPhone8
    case "iPhone10,2", "iPhone10,5":                return .iPhone8Plus
    case "iPhone10,3", "iPhone10,6":                return .iPhoneX
    case "iPhone11,2":                              return .iPhoneXS
    case "iPhone11,4", "iPhone11,6":                return .iPhoneXSMax
    case "iPhone11,8":                              return .iPhoneXR
    case "i386", "x86_64":                          return .Simulator
    default:
      return .Simulator
    }
  }
}
