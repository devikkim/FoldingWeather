//
//  NewSectionModel.swift
//  FoldingWeather
//
//  Created by InKwon on 07/02/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Domain
import RxDataSources

struct SectionWeather {
  var header: String
  var items: [Domain.Weather]
}

extension SectionWeather: SectionModelType {
  typealias Item = Domain.Weather
  
  init(original: SectionWeather, items: [Domain.Weather]) {
    self = original
    self.items = items
  }
}
