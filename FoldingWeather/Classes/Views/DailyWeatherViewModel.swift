//
//  DailyWeatherViewModel.swift
//  FoldingWeather
//
//  Created by InKwon on 14/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import RxSwift
import RxCocoa

class DailyWeatherViewModel {
  let model: DailyWeather
  
  lazy var day: Driver<String> = {
    return Observable.just(model.day)
    .asObservable()
    .asDriver(onErrorJustReturn: "")
  }()
  
  lazy var temperatureMax: Driver<String> = {
    return Observable.just(model.temperatureMax)
    .asObservable()
    .asDriver(onErrorJustReturn: "")
  }()
  
  lazy var temperatureMin: Driver<String> = {
    return Observable.just(model.temperatureMin)
      .asObservable()
      .asDriver(onErrorJustReturn: "")
  }()
  
  lazy var icon: Driver<String> = {
    return Observable.just(model.icon.emoji)
      .asObservable()
      .asDriver(onErrorJustReturn: "")
  }()
  
  init(model: DailyWeather){
    self.model = model
  }
}
