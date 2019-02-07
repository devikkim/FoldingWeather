//
//  Application.swift
//  FoldingWeather
//
//  Created by InKwon on 28/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Domain
import WeatherPlatform

final class Application {
  static let shared = Application()

  private let weatherUseCaseProvider: Domain.UseCaseProvider
  
  private init() {
    self.weatherUseCaseProvider = WeatherPlatform.UseCaseProvider()
  }
  
  func configureMainInterface(in window: UIWindow) {
    // TODO : DefaultWeatherNavigator
    
    let navigationController = UINavigationController()
    
    let navigator = WeatherNavigator(services: weatherUseCaseProvider, navigationController: navigationController)
    
    window.rootViewController = navigationController
    
    navigator.toFetchAll()
  }
}
