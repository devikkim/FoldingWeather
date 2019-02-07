//
//  ARCTest.swift
//  Domain
//
//  Created by InKwon on 31/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import Foundation

//강력순환참조
class Person {
  let name: String
  
  init(name: String){
    self.name = name
    
    print("\(name) is being initialized")
  }
  
  var apartment: Apartment?
  
  deinit {
    print("\(name) is being deinitialized")
  }
}

class Apartment {
  let number: Int
  
  init(number: Int){
    self.number = number
    print("Apartment #\(number) is being initialized")
  }
  
  var tenant: Person?
  
  deinit {
    print("Apartment #\(number) is being deinitialized")
  }
}


// 약한 참조
class WeakPerson {
  let name: String
  
  init(name: String){
    self.name = name
    
    print("\(name) is being initialized")
  }
  
  var apartment: WeakApartment?
  
  deinit {
    print("\(name) is being deinitialized")
  }
}

class WeakApartment {
  let number: Int
  init(number: Int){
    self.number = number
    print("Apartment #\(number) is being initialized")
  }
  
  weak var tenant: WeakPerson?
  
  deinit {
    print("Apartment #\(number) is being deinitialized")
  }
  
  
}

// 미소유 참조

class UnownedPerson {
  let name: String
  var apartment: UnownedApartment?
  
  init(name: String){
    self.name = name
    
    print("\(name) is being initialized")
  }
  
  deinit {
    print("\(name) is being deinitialized")
  }
}

class UnownedApartment {
  let number: Int
  unowned var tenant: UnownedPerson
  init(number: Int, tenant: UnownedPerson){
    self.number = number
    self.tenant = tenant
    
    print("Apartment #\(number) is being initialized")
  }
  deinit {
    print("Apartment #\(number) is being deinitialized")
  }
}

