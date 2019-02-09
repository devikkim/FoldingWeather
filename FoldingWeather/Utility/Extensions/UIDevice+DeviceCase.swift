//
//  UIDevice+modelName.swift
//  FoldingWeather
//
//  Created by InKwon on 07/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
  static let model: DeviceCase = {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    func mapToDevice(identifier: String) -> DeviceCase {
      #if os(iOS)
      return identifier.toDevice()!
      #endif
    }
    
    return mapToDevice(identifier: identifier)
  }()
  
}
