//
//  FruitsiOSAppTests.swift
//  FruitsiOSAppTests
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import XCTest
@testable import FruitsiOSApp

class FruitsiOSAppTests: XCTestCase,PayLoadFormat {
    
    var mockApiManager:MockApiManager?
    var apiModule:FruitsAPIModuleProtocol?
    var apiInteractor:FruitsApiInteractorProtocol?
    var fruitsViewModel: FruitsViewModelProtocol!

    override func setUp() {
        super.setUp()
        mockApiManager = MockApiManager()
        apiModule = FruitsAPIModule()
    }

    override func tearDown() {
        mockApiManager = nil
        apiModule = nil
        super.tearDown()
    }
    
    // MARK: - APIManager Unit testcases with Mock data
    
    func test_mock_ApiManager_success_fruit_data_response() {
       
       apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
    
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsInfo(payload: payload!, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNotNil(data)
                let fruitsCount:Int = data.fruits!.count
                XCTAssertEqual(fruitsCount , 9)
            case .failure(let error):
               XCTAssertNil(error)
            }
        })
    }
    
    func test_mock_ApiManager_failure_statuscode_400_fruit_data_response() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120},{\"type\":\"banana\", \"price\":129, \"weight\":80},{\"type\":\"blueberry\",\"price\":19, \"weight\":18},{\"type\":\"orange\", \"price\":199, \"weight\":150},{\"type\":\"pear\", \"price\":99, \"weight\":100},{\"type\":\"strawberry\", \"price\":99, \"weight\":20},{\"type\":\"kumquat\",\"price\":49, \"weight\":80},{\"type\":\"pitaya\", \"price\":599, \"weight\":100},{\"type\":\"kiwi\", \"price\":89, \"weight\":200}]}", mockResposne: mockResposne!)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsInfo(payload: payload!, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Unexpected status code")
            }
        })
    }
    
    func test_mock_ApiManager_decodable_failure_Invalid_Response_String() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"\":\"apple\", \"price\":149, \"weight\":120},{\"type\":\"banana\", \"price\":129, \"weight\":80},{\"type\":\"blueberry\",\"price\":19, \"weight\":18},{\"type\":\"orange\", \"\":199, \"weight\":150},{\"type\":\"pear\", \"price\":99, \"weight\":100},{\"type\":\"strawberry\", \"price\":99, \"weight\":20},{\"type\":\"kumquat\",\"price\":49, \"weight\":80},{\"type\":\"pitaya\", \"price\":599, \"weight\":100},{\"type\":\"kiwi\", \"price\":89, \"weight\":200}]}", mockResposne: mockResposne!)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsInfo(payload: payload!, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
            }
        })
    }
    
    func test_mock_ApiManager_Input_Request_with_no_URL_invalid_paylaod() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: nil)
        let payload = formatGetPayload(module: apiModule!)
        XCTAssertNil(payload)
        mockApiManager?.getFruitsInfo(payload: payload, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Invalid Payload")
            }
        })
    }
    
    func test_mock_ApiManager_Input_Request_with_no_eventType_invalid_paylaod() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: nil, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        let payload = formatGetPayload(module: apiModule!)
        XCTAssertNil(payload)
        mockApiManager?.getFruitsInfo(payload: payload, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Invalid Payload")
            }
        })
    }
    
    func test_mock_ApiManager_Input_Request_with_no_HttpMethod_invalid_paylaod() {
        
        apiModule = FruitsAPIModule(payloadType: nil, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        let payload = formatGetPayload(module: apiModule!)
        XCTAssertNil(payload)
        mockApiManager?.getFruitsInfo(payload: payload, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Invalid Payload")
            }
        })
    }
    
    // MARK: - Unit test case for FruitsApiInteractor
    
    func test_ApiInteractor_with_Mock_Api_Resposne() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
      
        apiInteractor = FruitsApiInteractor.init(apiModule: apiModule, apiManager: mockApiManager!)
        apiInteractor?.getFruitDataResponse(completion: { result, error in
            XCTAssertNil(error)
            XCTAssertNotNil(result)
           
            XCTAssertEqual( result![0].type, "apple")
            XCTAssertEqual( result![0].price, 149)
            XCTAssertEqual( result![0].weight, 120)
            
            XCTAssertEqual( result![1].type, "banana")
            XCTAssertEqual( result![1].price, 129)
            XCTAssertEqual( result![1].weight, 80)
            
            XCTAssertEqual( result![2].type, "blueberry")
            XCTAssertEqual( result![2].price, 19)
            XCTAssertEqual( result![2].weight, 18)
            
            XCTAssertEqual( result![3].type, "orange")
            XCTAssertEqual( result![3].price, 199)
            XCTAssertEqual( result![3].weight, 150)
            
            XCTAssertEqual( result![4].type, "pear")
            XCTAssertEqual( result![4].price, 99)
            XCTAssertEqual( result![4].weight, 100)
            
            XCTAssertEqual( result![5].type, "strawberry")
            XCTAssertEqual( result![5].price, 99)
            XCTAssertEqual( result![5].weight, 20)
            
            XCTAssertEqual( result![6].type, "kumquat")
            XCTAssertEqual( result![6].price, 49)
            XCTAssertEqual( result![6].weight, 80)
            
            XCTAssertEqual( result![7].type, "pitaya")
            XCTAssertEqual( result![7].price, 599)
            XCTAssertEqual( result![7].weight, 100)
            
            XCTAssertEqual( result![8].type, "kiwi")
            XCTAssertEqual( result![8].price, 89)
            XCTAssertEqual( result![8].weight, 200)
            
        })
        
    }
    
    // MARK: - Unit test case for Fruits View Model
    
    func test_ViewModel_with_Mock_Api_Resposne() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        XCTAssertNotNil(fruitsViewModel.dataForViewPub)
        XCTAssertNotNil(fruitsViewModel.fruitInfo)
        
        let mappedData:[FruitResponseProtocol]! = fruitsViewModel.mapToViewModelProtocol(fruitsData: fruitsViewModel.fruitInfo)
        
        XCTAssertNotNil(mappedData)
        XCTAssertEqual(mappedData.count, 9)
        
        XCTAssertEqual( mappedData[0].type, "apple")
        XCTAssertEqual( mappedData[0].price, 149)
        XCTAssertEqual( mappedData[0].weight, 120)

    }
    
    // MARK: - Unit test case for Live ApiManager from Interactor, baseline can be set for any performance regression
    
   func test_Live_success_ApiManagerFromApiInteractor() {
       
       let expect = expectation(description: "API response completion")
      
       let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
     
       apiInteractor = FruitsApiInteractor.init(apiModule: apiModule, apiManager: APIManager())
       apiInteractor?.getFruitDataResponse(completion: { result, error in
           expect.fulfill()
           XCTAssertNotNil(result)
           XCTAssertNil(error)
           XCTAssertGreaterThan(result!.count, 0)
       })

       waitForExpectations(timeout: 40, handler: nil)
       
    }
    
    func test_Live_failure_ApiManagerFromApiInteractor() {
        
        let expect = expectation(description: "API response completion")
       
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: nil)
      
        apiInteractor = FruitsApiInteractor.init(apiModule: apiModule, apiManager: APIManager())
        apiInteractor?.getFruitDataResponse(completion: { result, error in
            expect.fulfill()
            XCTAssertNil(result)
            XCTAssertNotNil(error)
            
        })

        waitForExpectations(timeout: 40, handler: nil)
        
     }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
