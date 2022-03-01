//
//  ViewController.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import UIKit
import Combine

class FruitsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModelProtocol:FruitsViewModelProtocol?
    var fruitsModelProtocol: [FruitResponseProtocol]?
    var anyCancelable = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableView.automaticDimension
        requestFruitListFromFruitsViewModel()
    }
    
    func requestFruitListFromFruitsViewModel () {
        ActivityIndicator.showActivityIndicator(view: self.view)
        viewModelProtocol = FruitsViewModel()
        bindingOfViewWithFruitsViewModel()
        viewModelProtocol?.getFruitList()
    }

    /// Binding of View with ViewModel here Combine is used
    func bindingOfViewWithFruitsViewModel() {
        viewModelProtocol?.dataForViewPub
            .receive(on: DispatchQueue.main)
            .sink {[weak self] (dataView) in
                guard let dataView = dataView else {return}
                self?.fruitsModelProtocol = dataView
                self?.tableView.reloadData()
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
        
        viewModelProtocol?.errorPub
            .receive(on:DispatchQueue.main)
            .sink { (error) in
                guard let error = error else { return }
                AlertViewController.showAlert(withTitle:"Alert" , message: error.localizedDescription)
                ActivityIndicator.stopActivityIndicator()
            }
            .store(in: &anyCancelable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let cell = sender as? FruitTableViewCell else { return }
        guard let index = tableView.indexPath(for: cell)?.row else { return }
        guard let detailView = segue.destination as? FruitsDetailViewController else { return }        
        guard let dataValue = self.fruitsModelProtocol else {return }
        detailView.fruitModelProtocol = dataValue[index]
        
    }


}

