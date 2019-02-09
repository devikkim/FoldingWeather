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
  
  internal let didAutocompleWithSubject: PublishSubject<GMSPlace>
  internal let didFailAutocompleteWithErrorSubject: PublishSubject<Error>
  internal let wasCancelledSubject: PublishSubject<Void>
  
  
  init(gmsAutoCompleteVC: GMSAutocompleteViewController) {
    didAutocompleWithSubject = PublishSubject<GMSPlace>()
    didFailAutocompleteWithErrorSubject = PublishSubject<Error>()
    wasCancelledSubject = PublishSubject<Void>()
    
    super.init(parentObject: gmsAutoCompleteVC,
               delegateProxy: RxGMSAutocompleteViewControllerDelegateProxy.self)
  }
  
  static func registerKnownImplementations() {
    self.register{ RxGMSAutocompleteViewControllerDelegateProxy(gmsAutoCompleteVC: $0) }
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    didAutocompleWithSubject.asObserver().onNext(place)
    viewController.dismiss(animated: true, completion: nil)
  }
  
  // case get a error while searching
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    didFailAutocompleteWithErrorSubject.asObserver().onNext(error)
  }
  
  // case search cancel from user
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    wasCancelledSubject.asObserver().onNext(())
    viewController.dismiss(animated: true, completion: nil)
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
  
  public var didAutocomplete: Observable<GMSPlace> {
    return (delegate as! RxGMSAutocompleteViewControllerDelegateProxy)
      .didAutocompleWithSubject
      .asObservable()
  }
  
  public var didFailAutocompleteWithError: Observable<Error> {
    return (delegate as! RxGMSAutocompleteViewControllerDelegateProxy)
      .didFailAutocompleteWithErrorSubject
      .asObservable()
  }
  
  public var wasCancelled: Observable<Void> {
    return (delegate as! RxGMSAutocompleteViewControllerDelegateProxy)
      .wasCancelledSubject
      .asObservable()
  }
}
