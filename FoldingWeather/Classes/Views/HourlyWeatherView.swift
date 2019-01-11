//
//  SmallTemperatureView.swift
//  FoldingWeather
//
//  Created by InKwon on 20/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import UIKit
import SnapKit

class HourlyWeatherView: UIView {

  lazy var rootStackView = UIStackView()
  lazy var timeLabel = UILabel()
  lazy var temperatureLabel = UILabel()
  lazy var iconLabel = UILabel()
  lazy var precipProbabilityLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HourlyWeatherView {
  func setUI() {
    self.addSubview(rootStackView)
    
    rootStackView.axis = .vertical
    rootStackView.distribution = .equalSpacing
    rootStackView.spacing = 5
    
    // set constraints of rootStackView
    rootStackView.snp.makeConstraints{
      $0.width.height.equalToSuperview().multipliedBy(0.8)
      $0.center.equalToSuperview()
    }
    
    // set constraints of timeLabel
    rootStackView.addArrangedSubview(timeLabel)
    timeLabel.textAlignment = .center
    timeLabel.textColor = .white
    
    timeLabel.snp.makeConstraints{
      $0.width.equalToSuperview()
      $0.height.lessThanOrEqualToSuperview().multipliedBy(0.3)
    }
    
    //TODO
    rootStackView.addArrangedSubview(precipProbabilityLabel)
    precipProbabilityLabel.textAlignment = .center
    precipProbabilityLabel.textColor = UIColor(red:0.40, green:0.65, blue:0.90, alpha:1.0)
    precipProbabilityLabel.font = precipProbabilityLabel.font.withSize(13)
    
    precipProbabilityLabel.snp.makeConstraints{
      $0.width.equalToSuperview()
      $0.height.lessThanOrEqualToSuperview().multipliedBy(0.1)
    }
    
    // set constraints of weatherLabel
    rootStackView.addArrangedSubview(iconLabel)
    iconLabel.textAlignment = .center
    
    iconLabel.snp.makeConstraints{
      $0.width.equalToSuperview()
      $0.height.lessThanOrEqualToSuperview().multipliedBy(0.3)
    }

    let blankLabel = UILabel()
    blankLabel.text = " "
    blankLabel.textAlignment = .center
    blankLabel.font = blankLabel.font.withSize(15)
    rootStackView.addArrangedSubview(blankLabel)

    blankLabel.snp.makeConstraints{
      $0.width.equalToSuperview()
      $0.height.lessThanOrEqualToSuperview().multipliedBy(0.05)
    }
    
    // set constraints of temperatureLabel
    rootStackView.addArrangedSubview(temperatureLabel)
    temperatureLabel.textAlignment = .center
    temperatureLabel.textColor = .white
    
    temperatureLabel.snp.makeConstraints{
      $0.width.equalToSuperview()
      $0.height.lessThanOrEqualToSuperview().multipliedBy(0.3)
    }
  }
  
  func setModel(_ model: HourlyWeather) {
    timeLabel.text = model.time
    temperatureLabel.text = model.temperature
    iconLabel.text = model.icon.emoji
    
    if model.icon == .rain || model.icon == .snow{
      precipProbabilityLabel.text = model.precipProbability
    } else {
      precipProbabilityLabel.text = " "
    }
  }

}
