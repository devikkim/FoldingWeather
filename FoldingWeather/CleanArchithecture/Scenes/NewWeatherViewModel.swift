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

final class NewWeatherViewModel: ViewModelType {
  struct Input {
    let fetchTrigger: Driver<Void>
    let selection: Driver<IndexPath>
  }
  
  struct Output {
    let fetching: Driver<Bool>
    let error: Driver<Error>
    let weathers: Driver<[NewSectionWeather]>
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
        .map { user, searched -> [NewSectionWeather] in
          print("user: \(user)")
          print("searched: \(searched)")
          let userSection = NewSectionWeather(header: "User Location", items: [user])
          let searchedSection = NewSectionWeather(header: "Searched Location", items: searched)
          
          return [userSection, searchedSection]
      }
    }
    
    // indicator on/off
    let fetching = activityIndicator.asDriver()
    // if occurred error
    let errors = errorTracker.asDriver()

    // 선택한 indexpath 를 받으면 FoldingCell 의 open / close height를 반환
//    let selectedWeather = input.selection
//      .withLatestFrom(weathers) { (indexPath, weathers) -> Weather in
//        return weathers.
//    }
    
    return Output(fetching: fetching,
                  error: errors,
                  weathers: weathers)
  }
}
