//
//  WeatherViewController.swift
//  FoldingWeather
//
//  Created by InKwon Kim on 31/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import FoldingCell
import GooglePlaces
import RxDataSources
import SPPermission
import BetterSegmentedControl
import Gifu

//TODO: aqi 대응 하여 셀 배경색 변경할 것
/**
 0 - 50     : Good : green,
 51 - 100   : Moderate : yellow
 101 - 150  : Unhealthy for Sensitive Groups : orange
 151 - 200  : Unhealthy : red
 201 - 300  : Very Unhealthy : violet
 300 +      : Hazardous:  dark red
 */


class WeatherViewController: UIViewController {
  private let disposeBag = DisposeBag()

  var viewModel: NewWeatherViewModel!
  var cellHeights: [[CGFloat]] = [[WeatherCellInformation.cellSize.closeHeight], []]
  
  // seleect Degree unit
  let segmentControl = BetterSegmentedControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                                              segments: LabelSegment.segments(withTitles: ["℃", "℉"],
                                                                              normalFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
                                                                              normalTextColor: .lightGray,
                                                                              selectedFont: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!,
                                                                              selectedTextColor: .white),
                                              index: UInt(RealmDegreeManager.shared.select()),
                                              options: [.backgroundColor(.clear),
                                                        .indicatorViewBackgroundColor(.clear)])
  
  //TODO: init UITableview
  lazy var tableView = UITableView(frame: self.view.bounds, style: .grouped)
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if !SPPermission.isAllow(.locationWhenInUse){
      SPPermission.Dialog.request(with: [.locationWhenInUse], on: self, delegate: self)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureBackground()
    configureNavigationBar()
    configureTableView()
    bindViewModel()
  }
  
  func configureBackground(){
    let imageView = GIFImageView(frame: view.bounds)
    
    imageView.animate(withGIFNamed: "day") {}
    view.insertSubview(imageView, at: 0)
  }
  
  private func configureTableView() {
    self.view.addSubview(tableView)
    
    tableView.snp.makeConstraints{
      $0.width.height.equalToSuperview()
      $0.center.equalToSuperview()
    }
    
    tableView.estimatedRowHeight = WeatherCellInformation.cellSize.closeHeight
    tableView.rowHeight = UITableView.automaticDimension
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none

    if #available(iOS 10.0, *) {
      tableView.refreshControl = UIRefreshControl()
    }

    let nibName = UINib(nibName: "WeatherCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.view.backgroundColor = .clear
    navigationController?.hidesBarsOnSwipe = true
    
    let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    let leftButton = UIBarButtonItem(title: "ⓘ", style: .plain, target: self, action: nil)
    
    rightButton.tintColor = .white
    leftButton.tintColor = .white
    
    navigationItem.rightBarButtonItem = rightButton
    navigationItem.leftBarButtonItem = leftButton
    
    (rightButton.rx.tap).bind { [unowned self] in
      self.presentSearchViewController()
      }
      .disposed(by: disposeBag)
    
    (leftButton.rx.tap).bind { [unowned self] in
      self.persentInformationViewController()
      }
      .disposed(by: disposeBag)
    
    
    self.navigationController?.navigationBar.addSubview(segmentControl)
    
    segmentControl.snp.makeConstraints{
      $0.height.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.2)
      $0.center.equalToSuperview()
    }
  }
  
  private func bindViewModel() {
    assert(viewModel != nil)
    
    let viewDidAppear =
      rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
        .mapToVoid()
        .asDriverOnErrorJustComplete()
    
    let pull =
      (tableView.refreshControl!.rx)
        .controlEvent(.valueChanged)
        .asDriver()
    
    let input = NewWeatherViewModel.Input(fetchTrigger: Driver.merge(viewDidAppear, pull),
                                          selection: tableView.rx.itemSelected.asDriver())
    
    let output = viewModel.transform(input: input)
    
    let dataSource = RxTableViewSectionedReloadDataSource<NewSectionWeather>(configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell",
                                               for: indexPath) as! WeatherCell
      cell.newModel = item
      return cell
    })
    
    dataSource.titleForHeaderInSection = { dataSource, index in
      return dataSource.sectionModels[index].header
    }
    
    dataSource.canEditRowAtIndexPath = { dataSource, indexPath in
      return true
    }
    
    dataSource.canMoveRowAtIndexPath = { dataSource, indexPath in
      return true
    }
    
    
    output
      .weathers
      .throttle(0.3)
      .drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    output.weathers.asObservable()
      .observeOn(MainScheduler.instance)
      .bind{ self.cellHeights[1] = [CGFloat](repeating: 116, count: $0[1].items.count) }
      .disposed(by: disposeBag)
    
    output.fetching
      .drive(tableView.refreshControl!.rx.isRefreshing)
      .disposed(by: disposeBag)
    
    tableView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
  }
}

extension WeatherViewController {
  func presentSearchViewController(){
    let searchVC = SearchViewController()
    searchVC.delegate = self
    present(searchVC, animated: true, completion: nil)
  }
  
  func persentInformationViewController(){
    // TODO: Imformation ViewController
  }
}



//FIXME: Delegate 를 Rx와 바인딩 하는 부분 만들 것
/**
 
 - UITableViewDelegate
 - GMSAutocompleteViewControllerDelegate
 - SPPermissionDialogDelegate
 
 */
extension WeatherViewController: UITableViewDelegate {
  // custom section header
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    view.tintColor = UIColor.red
    let header = view as! UITableViewHeaderFooterView
    header.textLabel?.textColor = UIColor.white
  }
  
  // set section header
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  // specified row is now selected.
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! WeatherCell
    
    let cellIsCollapsed = cellHeights[indexPath.section][indexPath.row] == WeatherCellInformation.cellSize.closeHeight
    if cellIsCollapsed {
      cellHeights[indexPath.section][indexPath.row] = WeatherCellInformation.cellSize.openHeight
      cell.unfold(true, animated: true, completion: nil)
    } else {
      cellHeights[indexPath.section][indexPath.row] = WeatherCellInformation.cellSize.closeHeight
      cell.unfold(false, animated: true, completion: nil)
    }
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { () -> Void in
      tableView.beginUpdates()
      tableView.endUpdates()
    }, completion: nil)
  }
  
  // drawing cell
  func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard case let cell as WeatherCell = cell else {
      return
    }
    
    cell.backgroundColor = .clear
    
    if cellHeights[indexPath.section][indexPath.row] == WeatherCellInformation.cellSize.closeHeight {
      cell.unfold(false, animated: false, completion: nil)
    } else {
      cell.unfold(true, animated: false, completion: nil)
    }
  }
  
  // set height of cell.
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeights[indexPath.section][indexPath.row]
  }
}

extension WeatherViewController: SPPermissionDialogDelegate {
  func didAllow(permission: SPPermissionType){
    // if permission is allowd, then call reload
//    viewModel.reload.onNext(())
  }
}

extension WeatherViewController: GMSAutocompleteViewControllerDelegate {
  // case get a searched location information
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    print("location: \(location)")
    // TODO: viewModel 하고 연결하여 저장. viewDidAppear 보다 빠름. 그러니 저장만 하면됨.
    dismiss(animated: true, completion: nil)
  }
  
  // case get a error while searching
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }
  
  // case search cancel from user
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  // turn the network activity indicator on again
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  // turn the network activity indicator off again
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}
