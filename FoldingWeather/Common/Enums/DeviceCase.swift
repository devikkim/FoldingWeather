//
//  DeviceType.swift
//  FoldingWeather
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import UIKit

enum DeviceCase {
  case iPhone4
  case iPhone4s
  case iPhone5
  case iPhone5c
  case iPhone5s
  case iPhone6
  case iPhone6Plus
  case iPhone6s
  case iPhone6sPlus
  case iPhone7
  case iPhone7Plus
  case iPhoneSE
  case iPhone8
  case iPhone8Plus
  case iPhoneX
  case iPhoneXS
  case iPhoneXSMax
  case iPhoneXR
  case Simulator
  case `nil`
}

extension DeviceCase {
  var simulatorType: String {
    return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"
  }
  
  var openCellHeight: CGFloat {
    switch self {
    case .iPhone4, .iPhone4s:
      return 378
    case .iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE:
      return 447
    case .iPhone6, .iPhone6s, .iPhone7, .iPhone8:
      return 525
    case .iPhone6sPlus , .iPhone6Plus, .iPhone7Plus, .iPhone8Plus:
      return 580
    case .iPhoneX, .iPhoneXS:
      return 650
    case .iPhoneXSMax, .iPhoneXR:
      return 706
    case .Simulator:
      return simulatorType.toDevice()!.openCellHeight
    case .`nil`:
      return 0
    }
  }
}
