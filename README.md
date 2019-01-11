# FoldingWeather

Open source iOS Weather App written in RxSwift and MVVM architecture.

## Screenshots
<img alt="01_simulator_iphone" src="/References/Simulators.png?raw=true" width="870">
<img alt="gif" src="/References/1.launch.gif?raw=true" width="290">
<img alt="gif" src="/References/2.insert.gif?raw=true" width="290">
<img alt="gif" src="/References/3.delete.gif?raw=true" width="290">

## Features
- [x] Programmatically UI ([SnapKit](https://github.com/SnapKit/SnapKit))
- [x] Architecture ([RxSwift](https://github.com/ReactiveX/RxSwift) and MVVM)
- [x] Weather API ([Darksky](https://darksky.net))
- [x] Networking ([SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON))
- [x] Custom TableCell ([folding-cell](https://github.com/Ramotion/folding-cell))
- [x] Support Devices 4,4s,5,5s,se,6,6s,7,7s,8,8s,X,Xs,XsMax,XR (Don't support iPad)
- [x] Place auto complete ([Google Maps Platform](https://developers.google.com/places/ios-sdk/start))
- [x] Database ([Realm](https://realm.io/kr/docs/swift/latest/))
- [x] Permission ([SPPermission](https://github.com/IvanVorobei/SPPermission))
- [ ] Information view conroller  
- [ ] Error Alert
- [ ] App Store application

## Building and Running
Just install pod dependencies
```sh
pod install
```

## Design
All icons is Unicode, the default icons supported by Apple.
The Background GIF was download ([gifer](https://gifer.com/en))

## References
* [SnapKit](https://github.com/SnapKit/SnapKit) - Programmatically UI
* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Darksky](https://darksky.net) - Weather API
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) - JSON and Network
* [Folding-cell](https://github.com/Ramotion/folding-cell) - UI
* [Google Maps Platform](https://developers.google.com/places/ios-sdk/start) - Auto complete place
* [SPPermission](https://github.com/IvanVorobei/SPPermission) - Device Permisson
* [Gifu](https://github.com/kaishin/Gifu) - UI
* [BetterSegmentedControl](https://github.com/gmarm/BetterSegmentedControl) - UI
* [RealmSwift](https://realm.io/kr/docs/swift/latest/) - Database
* [iOS Weather App] - Weather cell
* [SwiftHub](https://github.com/khoren93/SwiftHub) - README document format 
## License
MIT License.
