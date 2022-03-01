//
//  FruitsListViewControllerDataSource.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation
import UIKit

// MARK: - Table data source delegates

extension FruitsListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.fruitsModelProtocol?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FruitTableViewCell.cellIdentifier, for: indexPath) as? FruitTableViewCell else {
            fatalError("no cell initialized")
        }
        guard let dataValue = self.fruitsModelProtocol else {return cell}
        cell.displayData(fruits:dataValue[indexPath.row] )
        
        return cell
    }
    
}
