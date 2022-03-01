//
//  FruitsApiInteractor.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation

protocol FruitsApiInteractorProtocol {
    
    var apiModule:FruitsAPIModuleProtocol {get set}
    var apiManager:APIManagerProtocol {get set}
    init(apiModule:FruitsAPIModuleProtocol,apiManager:APIManagerProtocol)
    func getFruitDataResponse(completion:@escaping (_ result:[FruitInfo]?,_ error:Error?) -> Void) -> Void
}

final class FruitsApiInteractor:PayLoadFormat,FruitsApiInteractorProtocol {
   
    var apiModule: FruitsAPIModuleProtocol
    var apiManager: APIManagerProtocol
    
    init(apiModule: FruitsAPIModuleProtocol, apiManager: APIManagerProtocol) {
        self.apiModule = apiModule
        self.apiManager = apiManager
    }
    
    func getFruitDataResponse(completion: @escaping ([FruitInfo]?, Error?) -> Void) {
        
        guard let payload = formatPayLoad(apiModel:self.apiModule) else {
            completion(nil,NetworkError.invalidPayload)
            return}
        self.apiManager.getFruitsInfo(payload:payload) { result in
            switch result {
            case .success(let data):
                completion(data.fruits,nil)
            case .failure(let error):
                completion(nil,error)
            }
        }
    }
    
    func formatPayLoad(apiModel:FruitsAPIModuleProtocol) -> FruitsHTTPPayloadProtocol? {
        let payload = formatGetPayload(module:apiModel)
        guard let payload = payload else {return nil}
        return payload
    }
}
