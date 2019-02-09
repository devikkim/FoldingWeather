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
  
  var viewModel: WeatherViewModel!
  var cellHeights: [[CGFloat]] = [[WeatherCellInformation.cellSize.closeHeight], []]
  
  // seleect Degree unit
  let segmentControl = BetterSegmentedControl(
    frame: CGRect(x: 0, y: 0, width: 0, height: 0),
    segments: LabelSegment.segments(withTitles: ["℃", "℉"],
                                    normalFont: UIFont(name: "HelveticaNeue-Light",
                                                       size: 14.0)!,
                                    normalTextColor: .lightGray,
                                    selectedFont: UIFont(name: "HelveticaNeue-Bold",
                                                         size: 14.0)!,
                                    selectedTextColor: .white),
    index: UInt(RealmDegreeManager.shared.select()),
    options: [.backgroundColor(.clear),
              .indicatorViewBackgroundColor(.clear)]
  )
  
  let searchVC = SearchViewController()

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
    
    (rightButton.rx.tap).bind {
      self.presentSearchViewController()
      }
      .disposed(by: disposeBag)
    
    (leftButton.rx.tap).bind {
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
    tableView
      .rx
      .setDelegate(self)
      .disposed(by: disposeBag)
    
    tableView
      .rx
      .willDisplayHeaderView
      .bind{ $0.textLabel?.textColor = UIColor.white }
      .disposed(by: disposeBag)
    
    tableView.rx
      .didSelectRowAt
      .bind{ tableView, indexPath in
        let cell = tableView.cellForRow(at: indexPath) as! WeatherCell
        
        let cellIsCollapsed = self.cellHeights[indexPath.section][indexPath.row] == WeatherCellInformation.cellSize.closeHeight
        if cellIsCollapsed {
          self.cellHeights[indexPath.section][indexPath.row] = WeatherCellInformation.cellSize.openHeight
          cell.unfold(true, animated: true, completion: nil)
        } else {
          self.cellHeights[indexPath.section][indexPath.row] = WeatherCellInformation.cellSize.closeHeight
          cell.unfold(false, animated: true, completion: nil)
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: { () -> Void in
          tableView.beginUpdates()
          tableView.endUpdates()
        }, completion: nil)
      }
      .disposed(by: disposeBag)
    
    tableView.rx
      .willDisplayWithFoldingCell
      .bind{ cell, indexPath in
        cell.backgroundColor = .clear
        
        if self.cellHeights[indexPath.section][indexPath.row] == WeatherCellInformation.cellSize.closeHeight {
          cell.unfold(false, animated: false, completion: nil)
        } else {
          cell.unfold(true, animated: false, completion: nil)
        }
      }
      .disposed(by: disposeBag)
    
    let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
      .mapToVoid()
      .asDriverOnErrorJustComplete()
    
    let pull = (tableView.refreshControl!.rx)
      .controlEvent(.valueChanged)
      .asDriver()
    
    let input = WeatherViewModel.Input(fetchTrigger: Driver.merge(viewDidAppear, pull),
                                       selection: tableView.rx.itemSelected.asDriver())
    
    let output = viewModel.transform(input: input)
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionWeather>(configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell",
                                               for: indexPath) as! WeatherCell
      cell.model = item
      return cell
    })
    
    dataSource.titleForHeaderInSection = { dataSource, index in
      return dataSource.sectionModels[index].header
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
    
    output.error
      .asObservable()
      .subscribe({error in
        print("error: \(error.element.debugDescription)")
      })
      .disposed(by: disposeBag)
    
    searchVC.rx
      .didAutocomplete
      .subscribe(onNext: { place in
        //TODO: save coordinate
      })
      .disposed(by: disposeBag)
    
    searchVC.rx
      .didFailAutocompleteWithError
      .subscribe(onNext: {error in
        print("Error: \(error)")
      })
      .disposed(by: disposeBag)
    
  }
}

extension WeatherViewController {
  func presentSearchViewController(){
    present(searchVC, animated: true, completion: nil)
  }
}

//FIXME: convert delegate to reactive observable
extension WeatherViewController: UITableViewDelegate {
  // set section header
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 20
  }
  
  // set height of cell.
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeights[indexPath.section][indexPath.row]
  }
}

extension WeatherViewController: SPPermissionDialogDelegate {
  func didAllow(permission: SPPermissionType){
    print("allowed permission")
    //TODO : if permission is allowd, then call reload
  }
}
