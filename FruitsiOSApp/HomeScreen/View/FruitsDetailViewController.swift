//
//  FruitsDetailViewController.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import UIKit

class FruitsDetailViewController: UIViewController {

    var fruitModelProtocol: FruitResponseProtocol?
    var usageStatsViewModel:UsageStatsViewModelProtocol?
    var fruitsDetailDataFormatter :FruitsDetailDataFormatter?
    
    /// UiLabels are forced unwrap since it is property of Storyboard Interface Builder and it is always expected to have an instance value.
    @IBOutlet weak var fruitNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    private var fruit:String?
    private var price:String?
    private var weight:String?
    
    /// injecting data formator -validator object so that unit test can be performed
    init (validation:FruitsDetailDataFormatter) {
        self.fruitsDetailDataFormatter = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.fruitsDetailDataFormatter = FruitsDetailDataFormatter()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Fruit details"
        validateAndShowFruitDetails()
        /// send usages data for load time from tapping on the cell from list view controller till it show the details screen.
        self.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_display, error:nil)
    }
    
   private func validateAndShowFruitDetails() -> Void {
        do {
            fruit = try fruitsDetailDataFormatter?.getFruitname(fruitModelProtocol)
            fruitNameLabel?.text = fruit
        } catch {
            fruitNameLabel?.text = error.localizedDescription
            self.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_error, error:error)
        }
        
        do {
            price = try fruitsDetailDataFormatter?.getPrice(fruitModelProtocol)
            priceLabel?.text = price
        }  catch {
            priceLabel?.text = error.localizedDescription
            self.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_error, error:error)
        }
        
        do {
            weight = try fruitsDetailDataFormatter?.getWeightInKg(fruitModelProtocol)
            weightLabel?.text = weight
        }  catch {
            weightLabel?.text = error.localizedDescription
            self.usageStatsViewModel?.processUsageStats(withEventType: FruitsEventType.event_error, error:error)
        }
    }

}
