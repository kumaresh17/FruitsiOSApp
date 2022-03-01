//
//  FruitsDetailViewController.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import UIKit

class FruitsDetailViewController: UIViewController {

    var fruitModelProtocol: FruitResponseProtocol?
    var detailValidator :FruitsDetailValidator?
    
    @IBOutlet weak var fruitNameLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel?
    @IBOutlet weak var weightLabel: UILabel?
    
    var fruit:String?
    var price:String?
    var weight:String?
    
    init (validation:FruitsDetailValidator) {
        self.detailValidator = validation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.detailValidator = FruitsDetailValidator()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAndShowFruitDetails()
    }
    
    func validateAndShowFruitDetails() -> Void {
        do {
            fruit = try detailValidator?.getFruitname(fruitModelProtocol)
            fruitNameLabel?.text = fruit
        } catch {
            fruitNameLabel?.text = error.localizedDescription
           // presenter?.sendUsagesStatesFruitsList(eventName: FruitsEventType.event_error, dataDescription: error.localizedDescription)
        }
        
        do {
            price = try detailValidator?.getPrice(fruitModelProtocol)
            priceLabel?.text = price
        }  catch {
            priceLabel?.text = error.localizedDescription
            //presenter?.sendUsagesStatesFruitsList(eventName: FruitsEventType.event_error, dataDescription: error.localizedDescription)
        }
        
        do {
            weight = try detailValidator?.getWeightInKg(fruitModelProtocol)
            weightLabel?.text = weight
        }  catch {
            weightLabel?.text = error.localizedDescription
           // presenter?.sendUsagesStatesFruitsList(eventName: FruitsEventType.event_error, dataDescription: error.localizedDescription)
        }
    }

}
