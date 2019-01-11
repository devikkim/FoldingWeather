//
//  CurrentlyWeatherModel.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation
import CoreLocation

struct CurrentlyWeather{
  let icon: IconCase
  let time: String
  let location: String
  let summary: String
  let temperature: String
}
