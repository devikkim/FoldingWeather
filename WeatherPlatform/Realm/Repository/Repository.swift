//
//  Repository.swift
//  WeatherPlatform
//
//  Created by InKwon on 29/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift
import RxRealm
import Domain


final class Repository {
  
  private let configuration: Realm.Configuration
  private let scheduler: RunLoopThreadScheduler
  
  private var realm: Realm {
    return try! Realm(configuration: self.configuration)
  }
  
  init(configuration: Realm.Configuration) {
    self.configuration = configuration
    let name = "com.devikkim.WeatherPlatform.Repository"
    self.scheduler = RunLoopThreadScheduler(threadName: name)
  }
  
  func fetchAll() -> Observable<[Location]> {
    return Observable.deferred{
      let realm = self.realm
      let object = realm.objects(Location.RealmType.self)
      
      return Observable.array(from: object).mapToDomain()
    }
    .subscribeOn(scheduler)
  }
  
  func save(entity: Location) -> Observable<Void> {
    return Observable.deferred{
      return self.realm.rx.save(entity: entity)
    }.subscribeOn(scheduler)
  }
  
  func delete(entity: Location) -> Observable<Void> {
    return Observable.deferred{
      return self.realm.rx.delete(entity: entity)
    }.subscribeOn(scheduler)
  }
}
