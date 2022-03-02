//
//  UsageStatsViewModel.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 02/03/2022.
//

import Foundation

protocol UsageStatsViewModelProtocol {
    
    func sendUsagesStatsFruitsList(withEventType eventType:FruitsEventType?, andDataDescription dateDescription:String?) -> Void
}

class UsageStatsViewModel:UsageStatsViewModelProtocol,PayLoadFormat {
    
    var apiManagerProtocol:APIManagerProtocol?
    var payloadDataProtocol:FruitsHTTPPayloadProtocol?
    
    /** Dependency injection with payloadData and Api manager so that we can perform unit test with Mock stub data **/
    init(apiModule:FruitsAPIModuleProtocol,apiManager:APIManagerProtocol) {
        self.payloadDataProtocol = formatGetPayload(module:apiModule)
        self.apiManagerProtocol = apiManager
    }
    
    /// This convenince int will be called from the view with default parameters set for desiginated initializer
    convenience init (withEventType eventType:FruitsEventType, andEventData eventData:String?) {
        self.init(apiModule: FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  eventType, apiParameterEventData: eventData, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl), apiManager:APIManager())
    }

    func sendUsagesStatsFruitsList(withEventType eventType:FruitsEventType?, andDataDescription dateDescription:String?) -> Void {
        
        apiManagerProtocol?.getFruitsStatusInfo(payload: self.payloadDataProtocol, completion: { result in
            
        })
    }
    
    
}
