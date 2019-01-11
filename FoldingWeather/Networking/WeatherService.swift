//
//  WeatherAPI.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import Alamofire
import Alamofire_SwiftyJSON


enum WeatherServiceError: Error {
  case connectionFail
  case cannotParse
  case doNotRegisterKey
  case cannotGetAddress
  case cannotGetTimeZone
}

class WeatherService {
  private var key: String?
  private var unit: String
  
  init(_ unit: Int) {
    self.unit = unit == 0 ? "si" : "us"
  }
  
  func setUserSecretKey(_ key: String){
    self.key = key
  }
  
  func getWeatherFrom(location:CLLocation, type: LocationCase) -> Observable<Weather>{
    guard let secureKey = key else {
      return Observable.error(WeatherServiceError.doNotRegisterKey)
    }
    
    let url =
      "https://api.darksky.net/forecast" +
      "/\(secureKey)" +
      "/\(location.coordinate.latitude),\(location.coordinate.longitude)?" +
      "units=\(unit)" +
      "&lang=\(LanguageCase.systemCode.toString)"
    
    return Observable.create {observer in
      Alamofire.request(url).responseSwiftyJSON { response in
        guard
          let json = response.value
          else {
            observer.onError(WeatherServiceError.connectionFail)
            return
        }
        
        guard
          let latitude = json["latitude"].double,
          let longitude = json["longitude"].double else {
            observer.onError(WeatherServiceError.cannotParse)
            return
        }
        
        let location = CLLocation(latitude: latitude , longitude: longitude)
        let geocoder = CLGeocoder()
        
        // TODO: 주소얻어오는 부분 구글로 변경.
        geocoder.reverseGeocodeLocation(location) {(placemarks, error) in
          if (error != nil) {
            observer.onError(WeatherServiceError.cannotGetAddress)
            return
          }
          
          if let address: [CLPlacemark] = placemarks {
            guard let locationString = (address.last?.locality != nil) ? address.last?.locality : address.last?.country else {
              observer.onError(WeatherServiceError.cannotGetAddress)
              return
            }
            
            guard let timeZone = address.first?.timeZone else {
              observer.onError(WeatherServiceError.cannotGetTimeZone)
              return
            }
            
            let parser = WeatherJSONParser(timeZone)

            guard
              let dailyWeathers = parser.getDailyWeathersFrom(json),
              let currentlyWeather = parser.getCurrentlyWeatherFrom(json, location: locationString),
              let hourlyWeathers = parser.getHourlyWeathersFrom(json)
              else {
                observer.onError(WeatherServiceError.cannotParse)
                return
            }
            
            let model = Weather(currentlyWeather: currentlyWeather,
                                hourlyWeathers: hourlyWeathers,
                                dailyWeathers: dailyWeathers,
                                locationType: type,
                                latitude: latitude,
                                longitude: longitude)
            
            observer.onNext(model)
            observer.onCompleted()
          }
        }
      }
      
      return Disposables.create { }
    }
    
  }

}
