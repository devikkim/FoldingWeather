//
//  SectionWeather.swift
//  FoldingWeather
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionWeather {
  var header: String
  var items: [Weather]
}

extension SectionWeather: SectionModelType {
  typealias Item = Weather
  
  init(original: SectionWeather, items: [SectionWeather.Item]) {
    self = original
    self.items = items
  }
}
