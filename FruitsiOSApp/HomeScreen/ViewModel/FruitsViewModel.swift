//
//  FruitsViewModel.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation
import UIKit
import Combine

protocol FruitsViewModelProtocol {
    
    var dataForViewPub: Published<[FruitResponseProtocol]?>.Publisher { get  }
    var errorPub: Published<Error?>.Publisher { get  }
    func getFruitList() -> Void
    func mapToViewModelProtocol(fruitsData:[FruitInfo]?) -> [FruitResponseProtocol]?
   
}

class FruitsViewModel:FruitsViewModelProtocol {
   
    /**
     Combine Publisher for which we have binded with View
     */
    @Published var dataForView:[FruitResponseProtocol]?
    @Published var error:Error?
    var dataForViewPub: Published<[FruitResponseProtocol]?>.Publisher {$dataForView}
    var errorPub: Published<Error?>.Publisher {$error}
    
    var apiModuleProtocol: FruitsAPIModuleProtocol
    var apiInteractor:FruitsApiInteractorProtocol
    var fruitInfo:[FruitInfo]?
    
    
    /**Dependency injection with ApiModule and Api manager**/
    init(apiModule:FruitsAPIModuleProtocol,apiManager:APIManagerProtocol) {
        self.apiModuleProtocol = apiModule
        self.apiInteractor = FruitsApiInteractor.init(apiModule: self.apiModuleProtocol, apiManager: apiManager)
    }
    
    /// This convenince int wil be called from the view 
    convenience init () {
        self.init(apiModule: FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl), apiManager:APIManager())
    }
    
    func getFruitList() -> Void {
        apiInteractor.getFruitDataResponse {[weak self] resultData, error in
            self?.fruitInfo = resultData
            self?.error = error
            self?.dataForView =  self?.mapToViewModelProtocol(fruitsData: resultData)
        }
    }
    /**
     Mapping  FruitInfo array of Object to FruitResponseProtocol
     Avoid using concrete Codable objects directly, instead used a FruitResponseProtocol
     Prepare Data which is required to display on the View
     */
    func mapToViewModelProtocol(fruitsData:[FruitInfo]?) -> [FruitResponseProtocol]? {
        guard let fruitsData = fruitsData else {
            return nil
        }
        var result:[FruitResponseProtocol]? = [FruitResponseProtocol]()

        _ = fruitsData.map {
            let response = (FruitResponse(type: $0.type, price: $0.price, weight: $0.weight))
            result?.append(response)
        }
        return result
    }
    
}
