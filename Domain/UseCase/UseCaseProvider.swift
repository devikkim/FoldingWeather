//
//  UseCaseProvider.swift
//  Domain
//
//  Created by InKwon Kim on 26/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

public protocol UseCaseProvider {
  
  /// make weather use case
  ///
  /// - Returns: WeatherUseCase
  func makeWeatherUseCase() -> WeatherUseCase
}
