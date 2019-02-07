# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def rx_swift
  pod 'RxSwift', '~> 4.0'
end

def rx_cocoa
  pod 'RxCocoa', '~> 4.0'
end

def test_pods
  pod 'RxTest'
  pod 'RxBlocking'
  pod 'Nimble'
end

target 'FoldingWeather' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FoldingWeather
  
  # Networking
  pod 'Alamofire-SwiftyJSON'
  
  # UI
  pod 'BetterSegmentedControl', '~> 1.0'
  pod 'FoldingCell'
  pod 'Gifu'
  pod 'SnapKit', '~> 4.0.0'
  pod 'SPPermission'
  
  # GPS
  pod 'GooglePlaces'
  
  # Database
  pod 'RealmSwift'
  
  # Rx
  rx_swift
  rx_cocoa
  pod 'RxDataSources', '~> 3.0'
  
  target 'FoldingWeatherTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Domain' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  
  target 'DomainTests' do
    inherit! :search_paths
    test_pods
  end
  
end

target 'WeatherPlatform' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  rx_swift
  pod 'Alamofire'
  pod 'RxAlamofire'
  pod 'RxRealm', '~> 0.7.1'
  pod 'RealmSwift', '~> 3.10'
  pod 'Realm', '~> 3.10'
  
  target 'WeatherPlatformTests' do
    inherit! :search_paths
    test_pods
  end
  
end
