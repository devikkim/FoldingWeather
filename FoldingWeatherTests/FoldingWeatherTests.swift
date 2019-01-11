//
//  FoldingWeatherTests.swift
//  FoldingWeatherTests
//
//  Created by InKwon on 04/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import XCTest
import CoreLocation

@testable import FoldingWeather

class FoldingWeatherTests: XCTestCase {
  func testExample() {
    let array = [736, 667, 568, 480, 896]
    
    array.forEach{
      print("\(640 * $0 / 812)")
    }
    
    //37.8267,-122.4233
//    let date = Date(timeIntervalSince1970: TimeInterval(1546927352))
//    let timeFormat = DateFormatter()
//    timeFormat.timeZone = TimeZone(abbreviation: "GMT+9")
//    timeFormat.dateFormat = "HH:mm"
//    let timeString = timeFormat.string(from: date)
//
//    print(timeString)
  }
  
}
