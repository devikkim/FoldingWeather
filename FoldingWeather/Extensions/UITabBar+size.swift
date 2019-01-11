//
//  UITabBar+size.swift
//  FoldingWeather
//
//  Created by InKwon on 09/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
  override open func sizeThatFits(_ size: CGSize) -> CGSize {
    if #available(iOS 10, *) {
      super.sizeThatFits(size)
      guard let window = UIApplication.shared.keyWindow else {
        return super.sizeThatFits(size)
      }
      var sizeThatFits = super.sizeThatFits(size)
      sizeThatFits.height = window.safeAreaInsets.bottom + 35
      return sizeThatFits
      
    }
    super.sizeThatFits(size)
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 35
    
    return sizeThatFits
  }
}
