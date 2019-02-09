//
//  WeatherViewModel.swift
//  FoldingWeather
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

struct SectionHeaders {
  static let kUserLocation = "User Location"
  static let kSearchedLocation = "Searched Location"
}

final class WeatherViewModel: ViewModelType {

  struct Input {
    let fetchTrigger: Driver<Void>
    let selection: Driver<IndexPath>
  }
  
  struct Output {
    let fetching: Driver<Bool>
    let error: Driver<Error>
    let weathers: Driver<[SectionWeather]>
  }
  
  private let useCase: WeatherUseCase
  private let navigator: WeatherNavigator
  
  init(useCase: WeatherUseCase,
       navigator: WeatherNavigator) {
    self.useCase = useCase
    self.navigator = navigator
  }
  
  func transform(input: Input) -> Output {
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    let weathers = input.fetchTrigger.flatMapLatest {
      return Observable.combineLatest(self.useCase.fetch(),self.useCase.fetchAll())
        .trackActivity(activityIndicator)
        .trackError(errorTracker)
        .asDriverOnErrorJustComplete()
        .map { user, searched -> [SectionWeather] in
          let userSection = SectionWeather(header: SectionHeaders.kUserLocation, items: [user])
          let searchedSection = SectionWeather(header: SectionHeaders.kSearchedLocation, items: searched)
          
          return [userSection, searchedSection]
      }
    }
    
    let fetching = activityIndicator.asDriver()
    let errors = errorTracker.asDriver()

    return Output(fetching: fetching,
                  error: errors,
                  weathers: weathers)
  }
}
