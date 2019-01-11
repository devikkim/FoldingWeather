//
//  WeatherTableViewModel.swift
//  FoldingWeather
//
//  Created by InKwon on 02/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class WeatherViewModel{  
  private let disposeBag = DisposeBag()
  
  // internal request
  private let request: AnyObserver<[LocationCase]>
  
  // internal user location object
  private var userLocationSectionWeather = SectionWeather(header: "User Location", items: [])
  
  // internal searched location object
  private var searchLocationSectionWeather = SectionWeather(header: "Searched Location", items: [])
  
  // for insert location
  var insert: AnyObserver<LocationCase>
  
  // for reload added locations
  let reload: AnyObserver<Void>
  
  // for delete from cell indexPath.row
  let delete: AnyObserver<Int>
  
  // for subscribe weather informations
  let weathers: Observable<[SectionWeather]>
  
  init() {
    let _reload = PublishSubject<Void>()
    reload = _reload.asObserver()
    
    let _weathers = PublishSubject<[SectionWeather]>()
    weathers = _weathers.asObservable()
    
    let _insert = PublishSubject<LocationCase>()
    insert = _insert.asObserver()
    
    let _request = PublishSubject<[LocationCase]>()
    request = _request.asObserver()
    
    let _delete = PublishSubject<Int>()
    delete = _delete.asObserver()
    
    // combine response weathers
    _request.asObservable()
      .flatMap{types -> Observable<[Weather]> in
        return Observable.combineLatest(types.map{$0.getWeather(RealmDegreeManager.shared.select())})
      }
      .subscribe(
        onNext: { models in
          self.userLocationSectionWeather = SectionWeather(header: "User Location", items: models.filter{$0.locationType == .user})
          self.searchLocationSectionWeather = SectionWeather(header: "Searched Location", items: models.filter{$0.locationType != .user})
          
          _weathers.asObserver().onNext([self.userLocationSectionWeather, self.searchLocationSectionWeather])
      }, onError: {error in
        debugPrint("error : \(error)")
      })
      .disposed(by: disposeBag)
    
    // insert
    _insert.asObservable()
      .bind{ type in
        guard let location = type.location else {
          return
        }
        
        let coordinate = Coordinate()
        coordinate.latitude = location.coordinate.latitude
        coordinate.longitude = location.coordinate.longitude
        
        RealmCoordinateManager.shared.insert(coordinate)
        
        _reload.onNext(())
      }
      .disposed(by: disposeBag)
    
    // reload
    _reload.asObservable()
      .bind{
        var coordinates = [LocationCase]()
        if UIDevice.model != .Simulator{
          coordinates.append(.user)
        }
        
        let selectedCoordinates = RealmCoordinateManager.shared.select()
          .map{ coordi -> LocationCase in
            let location = CLLocation(latitude: coordi.latitude, longitude: coordi.longitude)
            return LocationCase.search(location)
          }
        coordinates.append(contentsOf: selectedCoordinates)
        
        self.request.onNext(coordinates)
      }
      .disposed(by: disposeBag)
    
    // delete
    _delete.asObservable()
      .bind{ index in
        self.searchLocationSectionWeather.items.remove(at: index)
        RealmCoordinateManager.shared.delete(index)
        
        _weathers.asObserver().onNext([self.userLocationSectionWeather, self.searchLocationSectionWeather])
      }
      .disposed(by: disposeBag)
  }
}
