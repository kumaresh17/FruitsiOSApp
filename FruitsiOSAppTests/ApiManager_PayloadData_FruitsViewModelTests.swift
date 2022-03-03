//
//  FruitsiOSAppTests.swift
//  FruitsiOSAppTests
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

/**
 Unit test cases for Mock APi manager, Api manager  JsonDecoder , Payload data  , View Model and binding between Viewmodel and View
 For all the cases of invalid resposne code, invalid data in resposne, missing parameter in response and as well as success cases.
 */

import XCTest
import Combine

@testable import FruitsiOSApp

class ApiManager_PayloadData_FruitsViewModelTests: XCTestCase,PayLoadFormat {
    
    var mockApiManager:MockApiManager?
    var apiModule:FruitsAPIModuleProtocol?
    var fruitsViewModel: FruitsViewModel!
    
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
    
    // MARK: - APIManager, view model Unit testcases with Mock data
    
    func test_mock_apimanager_failure_statuscode_400_fruit_data_response() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120},{\"type\":\"banana\", \"price\":129, \"weight\":80}]}", mockResposne: mockResposne!)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsInfo(payload: payload!, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, NetworkRequestResponseState.responseError.localizedDescription)
            }
        })
    }
    
    func test_mock_ApiManager_decodable_failure_Invalid_Response_String() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"\":\"apple\", \"\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
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
    
    func test_mock_ApiManager_decodable_failure_Empty_Response_String() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{}", mockResposne: mockResposne!)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsInfo(payload: payload!, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNil(data)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, NetworkRequestResponseState.inValidData.localizedDescription)
            }
        })
    }
    
    func test_mock_apimanager_success_fruit_data_response() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsInfo(payload: payload!, completion: { resultData in
            switch resultData {
            case .success(let data):
                XCTAssertNotNil(data)
                let fruitsCount:Int = data.fruits!.count
                XCTAssertEqual(fruitsCount , 9)
                let result =  data.fruits
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
            case .failure(let error):
                XCTAssertNil(error)
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
                XCTAssertEqual(error.localizedDescription, NetworkRequestResponseState.invalidPayload.localizedDescription)
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
                XCTAssertEqual(error.localizedDescription, NetworkRequestResponseState.invalidPayload.localizedDescription)
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
                XCTAssertEqual(error.localizedDescription, NetworkRequestResponseState.invalidPayload.localizedDescription)
            }
        })
    }
    
    
    // MARK: - Unit test case for Fruits View Model
    
    func test_ViewModel_with_Mock_Api_resposne_and_map_data_for_the_view_success() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        XCTAssertNotNil(fruitsViewModel.fruitInfo)
        XCTAssertNil(fruitsViewModel.error)
        
        let mappedDataForView:[FruitResponseProtocol]! = fruitsViewModel.mapToViewModelProtocol(fruitsData: fruitsViewModel.fruitInfo!)
        
        XCTAssertNotNil(mappedDataForView)
        XCTAssertEqual(mappedDataForView.count, 1)
        
        XCTAssertEqual( mappedDataForView[0].type, "apple")
        XCTAssertEqual( mappedDataForView[0].price, 149)
        XCTAssertEqual( mappedDataForView[0].weight, 120)
    }
    
    
    func test_ViewModel_with_Mock_Api_resposne_with_wrong_type_price_weight_fail() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":\"\", \"weight\":\"\"}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        XCTAssertNil(fruitsViewModel.fruitInfo)
        XCTAssertNotNil(fruitsViewModel.error)
        XCTAssertEqual(fruitsViewModel.error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
    }
    
    func test_ViewModel_with_Mock_Api_resposne_with_missing_price_weight_fail() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":, \"weight\":}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        XCTAssertNil(fruitsViewModel.fruitInfo)
        XCTAssertNotNil(fruitsViewModel.error)
        
        XCTAssertEqual(fruitsViewModel.error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
    }
    
    
    func test_ViewModel_with_Mock_Api_response_fail() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        XCTAssertNotNil(fruitsViewModel.error)
        XCTAssertNil(fruitsViewModel.fruitInfo)
        XCTAssertEqual(fruitsViewModel.error?.localizedDescription, NetworkRequestResponseState.responseError.localizedDescription)
    }
    
    func test_ViewModel_with_Mock_Api_response_data_invalid_fail() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"\":\"apple\", \"\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        XCTAssertNotNil(fruitsViewModel.error)
        XCTAssertEqual(fruitsViewModel.error?.localizedDescription, "The data couldn’t be read because it is missing.")
    }
    
    
    func test_viewmodel_with_mock_api_response_data_empty_fail() {
        
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockApiManager = MockApiManager(false, withMockData: "{}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        self.fruitsViewModel?.getFruitList()
        
        XCTAssertNotNil(fruitsViewModel.error)
        XCTAssertEqual(fruitsViewModel.error?.localizedDescription, NetworkRequestResponseState.inValidData.localizedDescription)
    }
    
    func test_mock_api_viewmodel_sink_with_data_response_forview() {
        
        let expect = expectation(description: "API response completion")
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        var anyCancelable = Set<AnyCancellable>()
        fruitsViewModel.dataForViewPub
            .receive(on: DispatchQueue.main)
            .sink {(result) in
                expect.fulfill()
                XCTAssertNotNil(result)
                XCTAssertEqual( result![0].type, "apple")
                XCTAssertEqual( result![0].price, 149)
                XCTAssertEqual( result![0].weight, 120)
            }
            .store(in: &anyCancelable)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_mock_api_viewmodel_sink_with_error_forview() {
        
        let expect = expectation(description: "API response completion")
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        fruitsViewModel = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        fruitsViewModel?.getFruitList()
        
        var anyCancelable = Set<AnyCancellable>()
        fruitsViewModel.errorPub
            .receive(on:DispatchQueue.main)
            .sink { (error) in
                expect.fulfill()
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.localizedDescription, NetworkRequestResponseState.responseError.localizedDescription)
            }
            .store(in: &anyCancelable)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Unit test case for Mock ApiManager from FruitsListViewController end to end
    
    func test_using_mock_api_viewmodel_binding_with_fruitListViewController_with_data_success() {
        
        let expect = expectation(description: "API response completion")
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        let vc = FruitsListTableViewController()
        let vm = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        vc.viewModelProtocol = vm
        vc.viewModelProtocol!.getFruitList()
        
        var anyCancelable = Set<AnyCancellable>()
        vc.viewModelProtocol!.dataForViewPub
            .receive(on: DispatchQueue.main)
            .sink {(result) in
                expect.fulfill()
                XCTAssertNotNil(result)
                XCTAssertEqual( result![0].type, "apple")
                XCTAssertEqual( result![0].price, 149)
                XCTAssertEqual( result![0].weight, 120)
            }
            .store(in: &anyCancelable)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    
    func test_using_mock_api_viewmodel_binding_with_fruitListViewController_with_error() {
        
        let expect = expectation(description: "API response completion")
        let apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType:  FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockApiManager = MockApiManager(false, withMockData: "{\"fruit\":[{\"type\":\"apple\", \"price\":149, \"weight\":120}]}", mockResposne: mockResposne!)
        
        let vc = FruitsListTableViewController()
        let vm = FruitsViewModel.init(apiModule: apiModule, apiManager: mockApiManager!)
        vc.viewModelProtocol = vm
        vc.viewModelProtocol!.getFruitList()
        
        var anyCancelable = Set<AnyCancellable>()
        vc.viewModelProtocol!.errorPub
            .receive(on: DispatchQueue.main)
            .sink {(error) in
                expect.fulfill()
                XCTAssertNotNil(error)
                XCTAssertEqual(error?.localizedDescription, NetworkRequestResponseState.responseError.localizedDescription)
            }
            .store(in: &anyCancelable)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    // MARK: - Unit test case for Live ApiManager, just to verify the Live URL and Response
    
    func test_live_success_apimanager() {

        let expect = expectation(description: "API response completion")

      let apimanager = APIManager()
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_FruitsList, apiParameterEventData: nil, fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let payload = formatGetPayload(module: apiModule!)
        
        apimanager.getFruitsInfo(payload: payload, completion: { resultData in
            expect.fulfill()
            switch resultData {
            case .success(let data):
                XCTAssertNotNil(data)
                let fruitsCount:Int = data.fruits!.count
                XCTAssertEqual(fruitsCount , 9)
                let result =  data.fruits
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
            case .failure(let error):
                XCTAssertNil(error)
            }
        })
       
        
        waitForExpectations(timeout: 40, handler: nil)

    }

        
    
}
