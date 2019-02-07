//
//  WeatherNavigator.swift
//  FoldingWeather
//
//  Created by InKwon Kim on 31/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit
import Domain

class WeatherNavigator {
  private let navigationController: UINavigationController
  private let services: UseCaseProvider
  
  init(services: UseCaseProvider,
       navigationController: UINavigationController) {
    self.services = services
    self.navigationController = navigationController
  }
  
  func toFetchAll() {
    let weatherVC = WeatherViewController()
    
    weatherVC.viewModel = NewWeatherViewModel(useCase: services.makeWeatherUseCase(),
                                              navigator: self)
    
    navigationController.pushViewController(weatherVC, animated: true)
  }
}
