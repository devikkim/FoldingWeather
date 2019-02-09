//
//  DailyWeatherView.swift
//  FoldingWeather
//
//  Created by InKwon on 24/12/2018.
//  Copyright © 2018 devikkim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Domain

class DailyWeatherView: UIView {
  lazy var rootStackView = UIStackView()
  
  lazy var dayLabel = UILabel()
  lazy var iconLabel = UILabel()
  
  lazy var temperatureMaxLabel = UILabel()
  lazy var temperatureMinLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DailyWeatherView {
  func setUI() {
    self.addSubview(rootStackView)
    rootStackView.axis = .horizontal
    
    rootStackView.snp.makeConstraints{
      $0.width.height.equalTo(self)
      $0.center.equalTo(self)
    }
    
    rootStackView.addArrangedSubview(dayLabel)
    dayLabel.textAlignment = .center
    dayLabel.textColor = .white
    
    dayLabel.snp.makeConstraints{
      $0.width.lessThanOrEqualToSuperview().multipliedBy(0.2)
      $0.height.equalToSuperview()
    }
    
    rootStackView.addArrangedSubview(iconLabel)
    iconLabel.textAlignment = .center
    iconLabel.textColor = .white
    
    iconLabel.snp.makeConstraints{
      $0.width.lessThanOrEqualToSuperview().multipliedBy(0.3)
      $0.height.equalToSuperview()
    }
    
    rootStackView.addArrangedSubview(temperatureMaxLabel)
    temperatureMaxLabel.textAlignment = .center
    temperatureMaxLabel.textColor = .white
    
    temperatureMaxLabel.snp.makeConstraints{
      $0.width.lessThanOrEqualToSuperview().multipliedBy(0.25)
      $0.height.equalToSuperview()
    }
    
    rootStackView.addArrangedSubview(temperatureMinLabel)
    temperatureMinLabel.textColor = .lightGray
    temperatureMinLabel.textAlignment = .center
    
    temperatureMinLabel.snp.makeConstraints{
      $0.width.lessThanOrEqualToSuperview().multipliedBy(0.25)
      $0.height.equalToSuperview()
    }
  }
  
  func setModel(_ model: Daily.Data) {
    dayLabel.text = model.time
    temperatureMaxLabel.text = model.temperatureMax
    temperatureMinLabel.text = model.temperatureMin
    iconLabel.text = model.icon.toIcon()!.emoji
  }
}
