//
//  MockApiManager.swift
//  FruitsiOSAppTests
//
//  Created by kumaresh shrivastava on 27/02/2022.
//
import Foundation
@testable import FruitsiOSApp

class MockApiManager {
    var shouldReturnError = false
    var getApiCalled = true
    
    let apiManager = APIManager()
    var mockURLResponse:HTTPURLResponse?
    var mockFruitResponse:String?
    
    enum MockServiceError:Error {
        case APIERROR
    }

    func reset(){
        shouldReturnError = false
        getApiCalled = false
    }
    
    /// this convinience init is used for mocking for get fruits list Apis
    convenience init() {
        self.init(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120},{\"type\":\"banana\", \"price\":129, \"weight\":80},{\"type\":\"blueberry\",\"price\":19, \"weight\":18},{\"type\":\"orange\", \"price\":199, \"weight\":150},{\"type\":\"pear\", \"price\":99, \"weight\":100},{\"type\":\"strawberry\", \"price\":99, \"weight\":20},{\"type\":\"kumquat\",\"price\":49, \"weight\":80},{\"type\":\"pitaya\", \"price\":599, \"weight\":100},{\"type\":\"kiwi\", \"price\":89, \"weight\":200}]}", mockResposne: HTTPURLResponse(url:URL.init(string:  "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
    }
    
    /// this convinience init is used for mocking for UsageStats Apis
    convenience init(withUsageStats:Bool,statusCode:Int){
        self.init(false, withMockData: "", mockResposne: HTTPURLResponse(url:URL.init(string:  "https://foo.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!)
    }
    
    init(_ shouldReturnError:Bool,withMockData:String,mockResposne:HTTPURLResponse) {
        self.shouldReturnError = shouldReturnError
        self.mockFruitResponse = withMockData
        self.mockURLResponse = mockResposne
    }
}


extension MockApiManager: APIManagerProtocol {
    
    func getFruitsStatusInfo(payload: FruitsHTTPPayloadProtocol?, completion: @escaping (Result<String, Error>) -> Void) {
        self.sendRequest(payLoad:payload,completion:completion)
    }
    
    func getFruitsInfo(payload: FruitsHTTPPayloadProtocol?, completion: @escaping (Result<FruitResponseModel, Error>) -> Void) {
        self.sendRequest(payLoad:payload,completion:completion)
    }
    
    func sendRequest<T:Codable>(payLoad:FruitsHTTPPayloadProtocol?,completion: @escaping (Result<T,Error>) -> Void) {
        
        getApiCalled = true
        let (urlRequest,error) = apiManager.prepareRequest(withPayload: payLoad)
        if error != nil  {
            completion(.failure(error!))
            return
        }
        guard urlRequest != nil else {
            completion(.failure(NetworkRequestResponseState.invalidRequestHeader))
            return
        }
        
        if shouldReturnError == true {
            completion(.failure(MockServiceError.APIERROR))
        } else {
            let data = Data(mockFruitResponse!.utf8)
            apiManager.jsonDecoder(data: data, response: mockURLResponse,completion: completion)
        }
    }

    
}
