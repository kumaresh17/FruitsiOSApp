//
//  FruitTableViewCell.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import UIKit

final class FruitTableViewCell: UITableViewCell {
    
    static var cellIdentifier = "FruitTableViewCell"
    
    @IBOutlet weak var fruitNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    /// Display data on table view cell
    ///
    /// - Parameter data: Results containing all info
    func displayData(fruits: FruitResponseProtocol) {

        if let title = fruits.type {
            fruitNameLabel.text = title
        } else {
            fruitNameLabel.text = "no fruits"
        }
        
    }

}
