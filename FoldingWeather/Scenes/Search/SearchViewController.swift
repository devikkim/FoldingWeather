//
//  SearchViewController.swift
//  FoldingWeather
//
//  Created by InKwon on 04/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class SearchViewController: GMSAutocompleteViewController {
  var searchBarTextColor: UIColor? = nil {
    willSet(color) {
      if let color = color{
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = color
      }
    }
  }
  
  var searchBarTintColor: UIColor? = nil {
    willSet(color){
      if let color = color{
        let appearance = UISearchBar.appearance()
        appearance.tintColor = color
      }
    }
  }
  
  var navigationBarTintColor: UIColor? = nil {
    willSet(color){
      if let color = color{
        let appearance = UINavigationBar.appearance()
        appearance.barTintColor = color
      }
    }
  }
  
  var navigationTintColor: UIColor? = nil {
    willSet(color){
      if let color = color{
        let appearance = UINavigationBar.appearance()
        appearance.tintColor = color
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set search tableview cell
    tableCellBackgroundColor = .black
    tableCellSeparatorColor = .gray
    
    primaryTextHighlightColor = .white
    primaryTextColor = .gray
    
    secondaryTextColor = .gray
    
    navigationTintColor = .white
    navigationBarTintColor = .clear
    
    searchBarTextColor = .gray
    searchBarTintColor = .white
  }
  
}
