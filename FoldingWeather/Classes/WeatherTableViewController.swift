//
//  WeatherTableViewController.swift
//  FoldingWeather
//
//  Created by InKwon on 02/01/2019.
//  Copyright © 2019 devikkim. All rights reserved.
//

import UIKit
import CoreLocation
import FoldingCell
import GooglePlaces
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import SPPermission
import BetterSegmentedControl
import Gifu

class WeatherTableViewController: UIViewController {
  let disposeBag = DisposeBag()
  
  var viewModel: WeatherViewModel!
  
  lazy var tableView = UITableView(frame: self.view.bounds, style: .grouped)
  
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
  
  
  // Folding-Cells height information cellHeights[0]: Section 1 , cellHeight[1]: Section 2
  var cellHeights: [[CGFloat]] = [[WeatherCellInformation.cellSize.closeHeight], []]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUI()
    setBinding()
    
    // Check Location Permission
    if !SPPermission.isAllow(.locationWhenInUse){
      SPPermission.Dialog.request(with: [.locationWhenInUse], on: self, delegate: self)
    }
  }
}

// Set Binding with ViewModel
extension WeatherTableViewController {
  func setBinding(){
    let dataSource = RxTableViewSectionedReloadDataSource<SectionWeather>(configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell",
                                               for: indexPath) as! WeatherCell
      
      cell.model = item
      
      let durations: [TimeInterval] = [0.26, 0.01, 0.01, 0.01, 0.01]
      
      cell.durationsForExpandedState = durations
      cell.durationsForCollapsedState = durations
      
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
    
    // bind delete
    tableView.rx.itemDeleted
      .filter{$0.section != 0}
      .bind{ indexPath in
        self.viewModel.delete.onNext(indexPath.row)
      }
      .disposed(by: disposeBag)
    
    // bind weathers with tableview items
    viewModel
      .weathers
      .observeOn(MainScheduler.instance)
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    // bind weathers count with self.cellHeights
    viewModel
      .weathers
      .bind{ models in
        self.cellHeights[1] = [CGFloat](repeating: 116, count: models[1].items.count)
      }
      .disposed(by: disposeBag)
    
    // bind delegate
    tableView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    // bind segmentControl event
    segmentControl.rx.controlEvent(.valueChanged)
      .map { RealmDegreeManager.shared.update(Int(self.segmentControl.rx.base.index)) }
      .bind { self.viewModel.reload.onNext(()) }
      .disposed(by: disposeBag)
    
  }
}

// Set UI
extension WeatherTableViewController {
  func setUI(){
    setGIFBackground()
    setNavigationBar()
    setTableView()
  }
  
  func setGIFBackground(){
    let imageView = GIFImageView(frame: view.bounds)
    
    imageView.animate(withGIFNamed: "day") {}
    view.insertSubview(imageView, at: 0)
  }
  
  func setNavigationBar(){
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
  
  func setTableView(){
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
      tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
    }
    
    let nibName = UINib(nibName: "WeatherCell", bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: "WeatherCell")
  }
  
  @objc func refreshHandler() {
    let deadlineTime = DispatchTime.now() + .seconds(1)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
      self?.viewModel.reload.on(.next(()))
      if #available(iOS 10.0, *) {
        self?.tableView.refreshControl?.endRefreshing()
      }
      self?.tableView.reloadData()
    })
  }
}

// Present Google Search ViewController
extension WeatherTableViewController {
  func presentSearchViewController(){
    let searchVC = SearchViewController()
    searchVC.delegate = self
    present(searchVC, animated: true, completion: nil)
  }
  
  func persentInformationViewController(){
    // TODO: Imformation ViewController
  }
}

// TableView Delegate for Folding-Cell
extension WeatherTableViewController: UITableViewDelegate {
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

// GMSAutocompleteViewController Delegate
extension WeatherTableViewController: GMSAutocompleteViewControllerDelegate {
  // case get a searched location information
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
    print("location: \(location)")
    viewModel.insert.asObserver().onNext(.search(location))
    
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

extension WeatherTableViewController: SPPermissionDialogDelegate {
  func didAllow(permission: SPPermissionType){
    // if permission is allowd, then call reload
    viewModel.reload.onNext(())
  }
}
