//
//  UsageStatsViewModel.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 02/03/2022.
//

import Foundation

protocol UsageStatsViewModelProtocol {
    func sendUsageState(withEventType eventType: FruitsEventType, error:Error?)
}

class UsageStatsViewModel:UsageStatsViewModelProtocol,PayLoadFormat {
    
    private var apiManagerProtocol:APIManagerProtocol?
    private var payloadDataProtocol:FruitsHTTPPayloadProtocol?
    
    /** Dependency injection with payloadData and Api manager so that we can perform unit test with Mock stub data **/
    init(apiModule:FruitsAPIModuleProtocol,apiManager:APIManagerProtocol) {
        self.payloadDataProtocol = formatGetPayload(module:apiModule)
        self.apiManagerProtocol = apiManager
    }
    
    /// This convenince int will be called from the view with default parameters set for desiginated initializer
    convenience init () {
        self.init(apiModule: FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  nil, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl), apiManager:APIManager())
    }

     func sendUsageState(withEventType eventType: FruitsEventType, error:Error?) {
      
       switch eventType {
       case FruitsEventType.event_display:
           /// send usages data for laod time from launch to  home screen with data reloaded completed.
           let timeLapsedInMilISecInString = Date.appViewLoadedComplete().fixedFraction(digits: 2)
           formatAndSendStats(withEventType: eventType, andDataDescription: timeLapsedInMilISecInString)
       case FruitsEventType.event_load:
           /// send usages data for api load time
           let dataInMilISecInString = Date.timelapsedSinceApiHit().fixedFraction(digits: 2)
           formatAndSendStats(withEventType: eventType, andDataDescription: dataInMilISecInString)
       case FruitsEventType.event_error:
           /// send usages data for any errors
           formatAndSendStats(withEventType: eventType, andDataDescription: error?.localizedDescription)
       default:
           debugPrint("do nothing")
       }
   }
    
    private func formatAndSendStats(withEventType eventType:FruitsEventType?, andDataDescription dateDescription:String?) -> Void {
       
       let apiModuleProtocol = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: eventType, apiParameterEventData: dateDescription, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
       self.payloadDataProtocol = formatGetPayload(module: apiModuleProtocol)
       
       apiManagerProtocol?.getFruitsStatusInfo(payload: self.payloadDataProtocol, completion: { result in
           /// since  app just sends the usages stats, no need to capture any return completion handler as of now, app don't intent to show the sucess or falure of the usages stats APi,
           /// However it is tested in the unit test with Mock data.
       })
   }
    
    
}
