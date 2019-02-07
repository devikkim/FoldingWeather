//
//  UseCaseProvider.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Domain
import Realm
import RealmSwift

public final class UseCaseProvider: Domain.UseCaseProvider {
  
  private let networkProvider: NetworkProvider
  private let repository: Repository
  private let configuration: Realm.Configuration
  
  public init(configuration: Realm.Configuration = Realm.Configuration()) {
    self.configuration = configuration
    self.networkProvider = NetworkProvider(weatherApiKey: "0c28aa7763d8751cefdae9b8e6e89a97",
                                           airApiKey: "057df0cd8cf3ceeb59c38273f9d763e6cad70428")
    
    self.repository = Repository(configuration: configuration)
    
  }
  
  public func makeWeatherUseCase() -> Domain.WeatherUseCase {
    return WeatherUseCase(network: networkProvider.makeWeatherProvider(),
                          repository: repository)
  }
  
  
}
