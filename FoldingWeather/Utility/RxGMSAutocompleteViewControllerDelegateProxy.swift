//
//  RxGMSAutocompleteViewControllerDelegateProxy.swift
//  FoldingWeather
//
//  Created by InKwon on 08/02/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GooglePlaces


extension GMSAutocompleteViewController: HasDelegate {
  public typealias Delegate = GMSAutocompleteViewControllerDelegate
}

extension DelegateProxyType where ParentObject: HasDelegate, Self.Delegate == ParentObject.Delegate {
  public static func currentDelegate(for object: ParentObject) -> Delegate? {
    return object.delegate
  }
  
  public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
    object.delegate = delegate
  }
  
}

class RxGMSAutocompleteViewControllerDelegateProxy:
  DelegateProxy<GMSAutocompleteViewController, GMSAutocompleteViewControllerDelegate>,
  DelegateProxyType,
  GMSAutocompleteViewControllerDelegate {
  
  public weak private(set) var gmsAutoCompleteVC: GMSAutocompleteViewController?
  
  init(gmsAutoCompleteVC: GMSAutocompleteViewController) {
    self.gmsAutoCompleteVC = gmsAutoCompleteVC
    super.init(parentObject: gmsAutoCompleteVC,
               delegateProxy: RxGMSAutocompleteViewControllerDelegateProxy.self)
  }
  
  static func registerKnownImplementations() {
    self.register{ RxGMSAutocompleteViewControllerDelegateProxy(gmsAutoCompleteVC: $0) }
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
  }
  
  // case get a error while searching
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
  }
  
  // case search cancel from user
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
  }
  
  // turn the network activity indicator on again
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  // turn the network activity indicator off again
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}


extension Reactive where Base: GMSAutocompleteViewController {
  public var delegate: DelegateProxy<GMSAutocompleteViewController, GMSAutocompleteViewControllerDelegate> {
    return RxGMSAutocompleteViewControllerDelegateProxy.proxy(for: base)
  }
  
  public var didAutocompleteWith: Observable<(GMSAutocompleteViewController, GMSPlace)> {
    let source = delegate.methodInvoked(#selector(GMSAutocompleteViewControllerDelegate.viewController(_:didAutocompleteWith:)))
      .map{ ($0[0] as! GMSAutocompleteViewController, $0[1] as! GMSPlace) }
    return source
  }
  
  public var didFailAutocompleteWithError: Observable<(GMSAutocompleteViewController, Error)> {
    let source = delegate
      .methodInvoked(#selector(GMSAutocompleteViewControllerDelegate.viewController(_:didFailAutocompleteWithError:)))
      .map{ ($0[0] as! GMSAutocompleteViewController, $0[0] as! Error ) }
    return source
  }
}
