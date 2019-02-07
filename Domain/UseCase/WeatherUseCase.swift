//
//  WeatherUseCase.swift
//  Domain
//
//  Created by InKwon Kim on 27/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift


/// WeatherUseCases are protocols which do about weather information.
public protocol WeatherUseCase {
  
  /// fetch weather informations of user location
  ///
  /// - Returns: Domain.Weather
  func fetch() -> Observable<Weather>
  
  /// fetch all weather informations of locations
  ///
  /// - Returns: Domain.Weather
  func fetchAll() -> Observable<[Weather]>
  
  /// save weather information
  ///
  /// - Parameter entity: Domain.Weather
  /// - Returns: Observable<Void>
  func save(entity: Location) -> Observable<Void>
  
  /// delete weather information
  ///
  /// - Parameter entity: Domain.Weather
  /// - Returns: Observable<Void>
  func delete(entity: Location) -> Observable<Void>
}
