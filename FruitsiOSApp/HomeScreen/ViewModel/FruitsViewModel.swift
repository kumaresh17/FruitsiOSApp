//
//  FruitsViewModel.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation
import Combine

// MARK: - Fruit home viewmodel

protocol FruitsViewModelProtocol {
    
    var dataForViewPub: Published<[FruitResponseProtocol]?>.Publisher { get  }
    var errorPub: Published<Error?>.Publisher { get  }
    func getFruitList() -> Void
}

final class FruitsViewModel:FruitsViewModelProtocol,PayLoadFormat {
    
    /** Combine Publisher for which we have binded with FruitListViewController **/
    @Published var dataForView:[FruitResponseProtocol]?
    @Published var error:Error?
    var dataForViewPub: Published<[FruitResponseProtocol]?>.Publisher {$dataForView}
    var errorPub: Published<Error?>.Publisher {$error}
    
    var fruitInfo:[FruitInfo]?
    private var apiManagerProtocol:APIManagerProtocol?
    private  var payloadDataProtocol:FruitsHTTPPayloadProtocol?
    
    /** Dependency injection with payloadData and Api manager so that we can perform unit test with Mock stub data **/
    init(apiModule:FruitsAPIModuleProtocol,apiManager:APIManagerProtocol) {
        self.payloadDataProtocol = formatGetPayload(module:apiModule)
        self.apiManagerProtocol = apiManager
    }
    
    /// This convenince int will be called from the view with default parameters set for desiginated initializer
    convenience init () {
        self.init(apiModule: FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl), apiManager:APIManager())
    }

    func getFruitList() -> Void {
        
        self.apiManagerProtocol?.getFruitsInfo(payload:self.payloadDataProtocol) { [weak self] result in
            switch result {
            case .success(let data):
                self?.fruitInfo = data.fruits
                /// Here self?.fruitInfo is forced unwrap because data failure cases has been handled in ApiManager jsondecoder extension, and verified by unit test with Mock data
                self?.dataForView = self?.mapToViewModelProtocol(fruitsData: (self?.fruitInfo)!)
            case .failure(let error):
                self?.error = error
            }
        }
    }

    /**
     Mapping  FruitInfo array of Concret Object to FruitResponseProtocol
     Avoid using concrete Codable objects directly, instead used a FruitResponseProtocol
     Prepare Data which is required to display on the View
     */
    func mapToViewModelProtocol(fruitsData:[FruitInfo]) -> [FruitResponseProtocol]? {

        var result:[FruitResponseProtocol]? = [FruitResponseProtocol]()

        _ = fruitsData.map {
            let response = (FruitResponse(type: $0.type, price: $0.price, weight: $0.weight))
            result?.append(response)
        }
        return result
    }
    
}
