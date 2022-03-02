//
//  ViewController.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import UIKit
import Combine


class FruitsListViewController: UIViewController {
    
    /// UITableview is forced unwrap since it is property of Storyboard Interface Builder and it is always expected to have an instance value.
    @IBOutlet weak var tableView: UITableView!
    
     var viewModelProtocol:FruitsViewModelProtocol?
     private  var usageStatsViewModel:UsageStatsViewModelProtocol?
     var fruitsModelProtocol: [FruitResponseProtocol]?
    
    /// To store the publisher streams, if we don't store,  publish streams will be cancelled immediately and we will not be able to get the sink the stream data from the publisher stream.
    var anyCancelable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        usageStatsViewModel = UsageStatsViewModel()
        requestFruitListFromFruitsViewModel()
    }
    
  private func requestFruitListFromFruitsViewModel () {
        ActivityIndicator.showActivityIndicator(view: self.view)
        viewModelProtocol = FruitsViewModel()
        bindingOfViewWithFruitsViewModel()
        // This is to pin the time when the api started, to calculate the time taken for the Api to compelete and send usage stats
        Date.currentDate()
        viewModelProtocol?.getFruitList()
    }

    /// Binding of View with ViewModel here Combine is used
  private func bindingOfViewWithFruitsViewModel() {
        viewModelProtocol?.dataForViewPub
            .receive(on: DispatchQueue.main)
            .sink {[weak self] (dataView) in
                guard let dataView = dataView else {return}
                self?.usageStatsViewModel?.sendUsageState(withEventType: FruitsEventType.event_load, error: nil)
                self?.fruitsModelProtocol = dataView
                self?.tableView.reloadData {
                    self?.usageStatsViewModel?.sendUsageState(withEventType: FruitsEventType.event_display, error: nil)
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
                self?.usageStatsViewModel?.sendUsageState(withEventType: FruitsEventType.event_error, error: error)
            }
            .store(in: &anyCancelable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? FruitTableViewCell else { return }
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        guard let detailView = segue.destination as? FruitsDetailViewController else { return }        
        guard let dataValue = self.fruitsModelProtocol else { return }
        Date.appViewStarted()
        detailView.fruitModelProtocol = dataValue[index]
    }

}

