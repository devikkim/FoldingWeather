//
//  WeatherCell.swift
//  FoldingWeather
//
//  Created by InKwon on 02/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit
import FoldingCell
import RxSwift
import RxCocoa

class WeatherCell: FoldingCell {
  
  @IBOutlet var foregroundTemperatureLabel: UILabel!
  @IBOutlet var foregroundLocationLabel: UILabel!
  
  @IBOutlet var containerTemperatureLabel: UILabel!
  @IBOutlet var containerLocationLabel: UILabel!
  @IBOutlet var containerSummeryLabel: UILabel!
  
  @IBOutlet var hourlyScrollView: UIScrollView!
  @IBOutlet var dailyScrollView: UIScrollView!
  
  lazy var hourlyStackView = UIStackView()
  lazy var dailyStackView = UIStackView()
  
  @IBOutlet var containerViewHeightConstraint: NSLayoutConstraint!
  
  var model: Weather? {
    get{
      return nil
    }
    
    set(newVal) {
      if let newModel = newVal {
        self.foregroundTemperatureLabel.text = newModel.currentlyWeather.temperature
        self.foregroundLocationLabel.text = newModel.currentlyWeather.location
        
        self.containerTemperatureLabel.text = newModel.currentlyWeather.temperature
        self.containerLocationLabel.text = newModel.currentlyWeather.location
        self.containerSummeryLabel.text = newModel.currentlyWeather.summary
        
        self.initHourlyWeatherViews(newModel.hourlyWeathers)
        self.initDailyWeatherViews(newModel.dailyWeathers)
        
        foregroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
      }
    }
  }
  
  override func awakeFromNib() {
    
    containerViewHeightConstraint.constant = WeatherCellInformation.constraint.containerViewHeight
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    
    hourlyStackView.translatesAutoresizingMaskIntoConstraints = false
    hourlyStackView.axis = .horizontal
    hourlyScrollView.addSubview(hourlyStackView)
    
    hourlyScrollView.isDirectionalLockEnabled = true
    
    // set constraints of hourlyStackView
    hourlyStackView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    dailyStackView.translatesAutoresizingMaskIntoConstraints = false
    dailyStackView.axis = .vertical
    dailyScrollView.addSubview(dailyStackView)
    
    
    
    // set constraints of dailyStackView
    dailyStackView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: AnimationType) -> TimeInterval {
    
    // durations count equal it itemCount
    let durations =  [0.26, 0.01, 0.01, 0.01, 0.01]
    return durations[itemIndex]
  }
}

extension WeatherCell {
  func initHourlyWeatherViews(_ models: [HourlyWeather]){
    for subView in hourlyStackView.subviews {
      subView.removeFromSuperview()
    }
    
    for model in models {
      let hourlyWeatherView = HourlyWeatherView()
      hourlyWeatherView.setModel(model)
      
      self.hourlyStackView.addArrangedSubview(hourlyWeatherView)
      
      hourlyWeatherView.snp.makeConstraints{
        $0.width.greaterThanOrEqualTo(self.hourlyScrollView).multipliedBy(0.125)
        $0.height.equalTo(self.hourlyScrollView)
      }
    }
  }
  
  func initDailyWeatherViews(_ models: [DailyWeather]){
    for subView in dailyStackView.subviews {
      subView.removeFromSuperview()
    }
    
    for model in models {
      let dailyWeatherView = DailyWeatherView()
      
      dailyWeatherView.setModel(model)
      
      self.dailyStackView.addArrangedSubview(dailyWeatherView)
      
      dailyWeatherView.snp.makeConstraints{
        $0.width.equalTo(self.dailyScrollView)
        $0.height.greaterThanOrEqualTo(self.dailyScrollView).multipliedBy(0.125)
      }
    }
  }
  
}
