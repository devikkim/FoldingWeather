//
//  WeatherPlatformTests.swift
//  WeatherPlatformTests
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import XCTest
import Domain
import RxSwift

@testable import WeatherPlatform

class WeatherPlatformTests: XCTestCase {
  let disposeBag = DisposeBag()
  let useCaseProvider = UseCaseProvider()
  
  let locations =
  [Location(latitude: 37.56653500, longitude: 126.97796920),
  Location(latitude: 35.86166000, longitude: 104.19539700),
  Location(latitude: 20.59368400, longitude: 78.96288000),
  Location(latitude: 37.09024000, longitude: -95.71289100),
  Location(latitude: -38.41609700, longitude: -63.61667200),
  Location(latitude: -30.55948200, longitude: 22.93750600),
  Location(latitude: 36.20482400, longitude: 138.2529240),
  Location(latitude: 48.85661400, longitude: 2.35222190),
  Location(latitude: 37.8267, longitude: -122.4239),
  Location(latitude: 35.16300090, longitude: 129.05317220)]
  
  let locations2 =
    [Location(latitude: 37.56653500, longitude: 126.97796920)]
  
  func testSave() {
    let expt = expectation(description: "testSave")
    
    var idx = 0
    
    for location in locations {
      useCaseProvider
        .makeWeatherUseCase()
        .save(entity: location)
        .subscribe(onNext:{
          print("saved")
          
          if idx == self.locations.count - 1 {
            expt.fulfill()
          } else {
            idx += 1
          }
        })
        .disposed(by: disposeBag)
    }
    
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testFetch() {
    let expt = expectation(description: "testFetch")
    
    useCaseProvider
      .makeWeatherUseCase()
      .fetch()
      .subscribe(
        onNext: { weather in
          print("aqi: \(weather.aqi)")
          print("time: \(weather.time)")
          expt.fulfill()
      }, onError: { error in
        print("error: \(error)")
        expt.fulfill()
      })
      .disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testFetchAll() {
    let expt = expectation(description: "testFetchAll")
    
    useCaseProvider
      .makeWeatherUseCase()
      .fetchAll()
      .subscribe(
        onNext: { weathers in
          print("weathers.count: \(weathers.count)")
          print(weathers)
          expt.fulfill()
      }, onError: { error in
        print("error: \(error)")
        expt.fulfill() 
      })
      .disposed(by: disposeBag)
    
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testDelete() {
    let expt = expectation(description: "testDelete")

    var idx = 0
    
    for location in locations {
      useCaseProvider
        .makeWeatherUseCase()
        .delete(entity: location)
        .subscribe(onNext: {
          print("deleted")
          
          if idx == self.locations.count - 1 {
            expt.fulfill()
          } else {
            idx += 1
          }
        })
        .disposed(by: disposeBag)
    }
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  func testBearing(){
    XCTAssertTrue(45.1.getBearing() == Bearing.NE.name)
  }
}
