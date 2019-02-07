//
//  FoldingWeatherTests.swift
//  FoldingWeatherTests
//
//  Created by InKwon on 04/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import XCTest
import Domain
import RxSwift
import RxCocoa

import WeatherPlatform

import CoreLocation

@testable import FoldingWeather

class FoldingWeatherTests: XCTestCase {
  
//  let disposeBag = DisposeBag()
//  
//  let location = Location(latitude: 37.8267, longitude: -122.4233)
//  let location2 = Location(latitude: 37.56653500, longitude: 126.97796920)
//  func testExample() {
//    let array = [736, 667, 568, 480, 896]
//
//    array.forEach{
//      print("\(640 * $0 / 812)")
//    }
//  }
//  
//  func testPlatforms() {
//    let expt = expectation(description: "weather")
//
//    let networkUseCaseProvider = NetworkPlatform.UseCaseProvider(unit: .si)
//    let realmUseCaseProvider = RealmPlatform.UseCaseProvider()
//
//    realmUseCaseProvider
//      .makeRealmUseCase()
//      .fetch()
//      .subscribe(onNext: { locations in
//        print("Realm Use Case Provider Locations Count: \(locations.count)")
//        print("Realm Use Case Provider Locations: \(locations)")
//
//        Observable.combineLatest(locations.compactMap{ location -> Observable<Domain.Weather> in
//          networkUseCaseProvider
//            .makeWeatherUseCase()
//            .fetch(location: location)
//        })
//          .subscribe(
//            onNext: { weathers in
//              print(weathers)
//
//              expt.fulfill()
//          },
//            onError: {error in
//              print (error)
//          })
//          .disposed(by: self.disposeBag)
//
//      }, onError: {error in
//        print("error: \(error)")
//      })
//      .disposed(by: self.disposeBag)
//
//    waitForExpectations(timeout: 10.0, handler: nil)
//  }
  
  func testFetch() {
    let useCase = WeatherPlatform.UseCaseProvider()
    
    
    let navigator = UINavigationController()
    let wnavi = WeatherNavigator(services: useCase, navigationController: navigator)
    
    let viewModel = NewWeatherViewModel(useCase: useCase.makeWeatherUseCase(),
                                        navigator: wnavi)
    
    }
}
