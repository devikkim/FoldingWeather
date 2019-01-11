//
//  WeatherCellInfomation.swift
//  FoldingWeather
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import UIKit

struct WeatherCellInformation{
  struct cellSize {
    static let closeHeight: CGFloat = 116
    static var openHeight: CGFloat {
      return UIDevice.model.openCellHeight + 16
    }
  }
  
  struct constraint {
    static var containerViewHeight: CGFloat {
    return UIDevice.model.openCellHeight
    }
  }
}
