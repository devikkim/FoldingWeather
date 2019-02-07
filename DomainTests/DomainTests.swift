//
//  DomainTests.swift
//  DomainTests
//
//  Created by InKwon on 23/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import XCTest
@testable import Domain

class DomainTests: XCTestCase {
  func testWeatherParsing(){
    if let path = Bundle.main.path(forResource: "WeatherTest", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let weather = try JSONDecoder().decode(Weather.self, from: data)
                
        XCTAssert(weather.sunriseTime == weather.daily.data[0].sunriseTime)
        XCTAssert(weather.sunsetTime == weather.daily.data[0].sunsetTime)
        XCTAssert(weather.icon == weather.currently.icon)
        
      } catch {
        print("\(error)")
      }
    } else {
      XCTAssert(false, "Failed Load JSON FILE")
    }
  }
  
  func testAirParsing(){
    if let path = Bundle.main.path(forResource: "AirTest", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let aqi = try JSONDecoder().decode(Air.self, from: data)
        
        XCTAssert(aqi.data.aqi == 173)
        
      } catch {
        print("\(error)")
      }
    } else {
      XCTAssert(false, "Failed Load JSON FILE")
    }
  }
}
