//
//  InitAPI.swift
//  FoldingWeather
//
//  Created by InKwon on 11/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import GooglePlaces

class API {
  static func setGoogleMapAPIKey(provideAPIKey: String){
    GMSPlacesClient.provideAPIKey(provideAPIKey)
  }
}
