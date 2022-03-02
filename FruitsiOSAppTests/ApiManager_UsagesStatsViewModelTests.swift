//
//  ApiManager_UsagesStatsViewModelTests.swift
//  FruitsiOSAppTests
//
//  Created by kumaresh shrivastava on 02/03/2022.
//

import XCTest
@testable import FruitsiOSApp

class ApiManager_UsagesStatsViewModelTests: XCTestCase,PayLoadFormat {

  
    var mockApiManager:MockApiManager?
    var apiModule:FruitsAPIModuleProtocol?
    var usageStatsViewModel: UsageStatsViewModel!
    
    override func setUp() {
        super.setUp()
        mockApiManager = MockApiManager.init(withUsageStats: true, statusCode: 200)
        apiModule = FruitsAPIModule()
    }
    
    override func tearDown() {
        mockApiManager = nil
        apiModule = nil
        super.tearDown()
    }
    
    /// It is the case when we get success response code but the data is empty so we are throwing error stating resposne code is sucsess but there is no data is resposne.
    func test_mock_usage_stats_api_eventdisplay_loadtime() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_display, apiParameterEventData: "100.2", fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsStatusInfo(payload: payload, completion: { result in
            switch result {
            case .success(let statusCode):
                XCTAssertEqual(statusCode, 200)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "EmptyData with valid Success response")
            }
        })
    }
    
    func test_mock_usage_stats_api_for_eventload_time() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_load, apiParameterEventData: "100.2", fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsStatusInfo(payload: payload, completion: { result in
            switch result {
            case .success(let statusCode):
                XCTAssertEqual(statusCode, 200)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "EmptyData with valid Success response")
            }
        })
    }
    
    func test_mock_usage_stats_api_for_eventerror() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_error, apiParameterEventData: "EmptyData with valid Success response", fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let payload = formatGetPayload(module: apiModule!)
        
        mockApiManager?.getFruitsStatusInfo(payload: payload, completion: { result in
            switch result {
            case .success(let statusCode):
                XCTAssertEqual(statusCode, 200)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "EmptyData with valid Success response")
            }
        })
    }
    
    
    func test_mock_usage_stats_api_for_eventload_time_failure() {
        
        apiModule = FruitsAPIModule(payloadType: FruitsHTTPPayloadType.requestMethodGET, apiParameterEventType: FruitsEventType.event_load, apiParameterEventData: "100.2", fruitsUrl: FruitsHTTPSUrl.fruitsHTTPSUrl)
        
        let payload = formatGetPayload(module: apiModule!)
        
        let mockResposne =  HTTPURLResponse(url:URL.init(string: "https://foo.com")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        mockApiManager = MockApiManager(false, withMockData: "", mockResposne: mockResposne!)
        
        mockApiManager?.getFruitsStatusInfo(payload: payload, completion: { result in
            switch result {
            case .success(let statusCode):
                XCTAssertEqual(statusCode, 200)
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error.localizedDescription, "Unexpected status code")
            }
        })
    }

}
