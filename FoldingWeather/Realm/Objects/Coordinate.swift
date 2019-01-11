//
//  Coordinate.swift
//  FoldingWeather
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RealmSwift

final class Coordinate: Object {
  @objc dynamic var latitude: Double = 0.0
  @objc dynamic var longitude: Double = 0.0
}

final class Coordinates: Object {
  var items = RealmSwift.List<Coordinate>()
  
}
