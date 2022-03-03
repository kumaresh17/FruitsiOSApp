//
//  ViewController.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import UIKit
import Combine


class FruitsListTableViewController: UITableViewController {
    
    var viewModelProtocol:FruitsViewModelProtocol?
    private  var usageStatsViewModel:UsageStatsViewModelProtocol?
    var fruitsModelProtocol: [FruitResponseProtocol]?
    
    /// To store the publisher streams, if we don't store,  publish streams will be cancelled immediately and we will not be able to get the sink the stream data from the publisher stream.
    private var anyCancelable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableView.automaticDimension
        setUpHomeScreen()
    }
    
    private func setUpHomeScreen()  {
        self.navigationItem.title = "Fruits"
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        ActivityIndicator.showActivityIndicator(view: self.view)
        viewModelProtocol = FruitsViewModel()
        bindingOfViewWithFruitsViewModel()
        usageStatsViewModel = UsageStatsViewModel()
        requestFruitListFromFruitsViewModel()
    }
    
    private func requestFruitListFromFruitsViewModel () {
        // This is to pin the time when the api started, to calculate the time taken for the Api to compelete and send usage stats
        Date.timeApiStarted()
        viewModelProtocol?.getFruitList()
    }
    
    @objc private func refresh(sender:AnyObject) {
        /// Capuring start time for the usage stats to be send when the table reload is completed with response.
        Date.timeWhenViewLoadStarted()
        requestFruitListFromFruitsViewModel()
        self.refreshControl?.endRefreshing()
    }
    
    /// Binding of View with ViewModel here Combine is used
    private func bindingOfViewWithFruitsViewModel() {
        viewModelProtocol?.dataForViewPub
            .receive(on: DispatchQueue.main)
            .sink {[weak self] (dataView) in
                guard let dataView = dataView else {return}
                self?.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_load, error: nil)
                self?.fruitsModelProtocol = dataView
                self?.tableView.reloadData {
                    self?.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_display, error: nil)
                }
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
        
        viewModelProtocol?.errorPub
            .receive(on:DispatchQueue.main)
            .sink { [weak self] (error) in
                guard let error = error else { return }
                AlertViewController.showAlert(withTitle:"Alert" , message: error.localizedDescription)
                ActivityIndicator.stopActivityIndicator()
                self?.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_error, error: error)
            }
            .store(in: &anyCancelable)
    }
    
   
    
}

