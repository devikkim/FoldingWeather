//
//  RxTableViewDelegateProxy.swift
//  FoldingWeather
//
//  Created by InKwon on 08/02/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
  
  public var willDisplayWithFoldingCell: ControlEvent<(WeatherCell, IndexPath)> {
    let source: Observable<(WeatherCell, IndexPath)> = self.delegate
      .methodInvoked(#selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:)))
      .map { ($0[1] as! WeatherCell, $0[2] as! IndexPath) }
    
    return ControlEvent(events: source)
  }
  
  public var didSelectRowAt: ControlEvent<(UITableView, IndexPath)> {
    let source: Observable<(UITableView, IndexPath)> = self.delegate
      .methodInvoked(#selector(UITableViewDelegate.tableView(_:didSelectRowAt:)))
      .map { ($0[0] as! UITableView, $0[1] as! IndexPath) }
    
    return ControlEvent(events: source)
  }
  
  public var willDisplayHeaderView: ControlEvent<UITableViewHeaderFooterView> {
    let source: Observable<UITableViewHeaderFooterView> = self.delegate
      .methodInvoked(#selector(UITableViewDelegate.tableView(_:willDisplayHeaderView:forSection:)))
      .map { $0[1] as! UITableViewHeaderFooterView }
    
    return ControlEvent(events: source)
  }
}

