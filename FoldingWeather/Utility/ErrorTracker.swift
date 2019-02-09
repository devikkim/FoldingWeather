//
//  ErrorTracker.swift
//  FoldingWeather
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
  typealias SharingStrategy = DriverSharingStrategy
  private let _subject = PublishSubject<Error>()
  
  func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.E> {
    return source.asObservable().do(onError: onError)
  }
  
  func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
    return _subject.asObservable().asDriverOnErrorJustComplete()
  }
  
  func asObservable() -> Observable<Error> {
    return _subject.asObservable()
  }
  
  private func onError(_ error: Error) {
    _subject.onNext(error)
  }
  
  deinit {
    _subject.onCompleted()
  }
}

extension ObservableConvertibleType {
  func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
    return errorTracker.trackError(from: self)
  }
}

