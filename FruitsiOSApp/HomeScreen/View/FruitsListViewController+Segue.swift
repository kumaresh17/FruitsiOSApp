//
//  FruitsListViewController+Segue.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 02/03/2022.
//

import Foundation
import UIKit

extension FruitsListTableViewController {
    
    /// Since it is a simple navigation to detail screen so using segue instead of router or coordinator design pattern
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? FruitTableViewCell else { return }
        guard let index = self.tableView.indexPath(for: cell)?.row else { return }
        guard let detailView = segue.destination as? FruitsDetailViewController else { return }
        guard let dataValue = self.fruitsModelProtocol else { return }
        Date.timeViewLoadStarted()
        detailView.fruitModelProtocol = dataValue[index]
    }
}
