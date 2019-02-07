//
//  Int+Ext.swift
//  Domain
//
//  Created by InKwon on 30/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

extension Int {

  func toFormattedDateFromTimestamp(dateFormat: String = "yyyy-MM-dd HH:mm:ss",
                                    timeZone: TimeZone? = nil) -> String {
    let timeFormatter = DateFormatter()
    
    timeFormatter.dateFormat = dateFormat
    
    let timeInterval = TimeInterval(self)
    let date = Date(timeIntervalSince1970: timeInterval)
    
    return timeFormatter.string(from: date)
  }
}
