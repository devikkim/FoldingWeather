//
//  WeatherUseCase.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Domain
import RxSwift

final class WeatherUseCase: Domain.WeatherUseCase {
  
  private let network: WeatherNetwork
  private let repository: Repository
  
  private let disposeBag = DisposeBag()
  
  init(network: WeatherNetwork, repository: Repository) {
    self.network = network
    self.repository = repository
  }
  
  func fetch() -> Observable<Weather> {
    return network.fetchWeather()
  }
  
  func fetchAll() -> Observable<[Weather]> {
    return repository
      .fetchAll()
      .flatMap { locations -> Observable<[Weather]> in
        if locations.count == 0 {
          return Observable.just([])
        }
        
        return Observable.combineLatest(locations.map{ self.network.fetchWeather(location: $0) })
      }
  }
  
  func save(entity: Location) -> Observable<Void> {
    return repository.save(entity: entity)
  }
  
  func delete(entity: Location) -> Observable<Void> {
    return repository.delete(entity: entity)
  }
  
}
