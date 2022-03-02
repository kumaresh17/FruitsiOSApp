//
//  FruitsPayload.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation

// MARK: - Payload data formation for request URL

protocol PayLoadFormat {

    func formatGetPayload(module: FruitsAPIModuleProtocol) -> FruitsHTTPPayloadProtocol?
}

extension PayLoadFormat  {
    
    func formatGetPayload(module: FruitsAPIModuleProtocol) -> FruitsHTTPPayloadProtocol?{
        guard let url = module.fruitsUrl else {return nil}
        guard let _ = module.apiParameterEventType else {return nil}
        guard let _ = module.payloadType else {return nil}
        var payload = FruitsHTTPPayload(url: url, payload: module)
        payload.headers = Dictionary<String, String>()
        payload.addHeader(name: FruitsHTTPHeaderType.contentType.rawValue, value: FruitsHTTPMimeType.applicationJSON.rawValue)
        return payload
    }
}

protocol FruitsHTTPPayloadProtocol {
    var type: FruitsHTTPPayloadType? { get }
    var headers: Dictionary<String, String>? { get set }
    var url: URL? {get}
}
/// Payload
struct FruitsHTTPPayload: FruitsHTTPPayloadProtocol {
    var type: FruitsHTTPPayloadType?
    var headers: Dictionary<String, String>?
    var url: URL?
    fileprivate init(url: FruitsHTTPSUrl, payload: FruitsAPIModuleProtocol) {
        self.type = payload.payloadType
        var components = URLComponents()
        components.scheme = FruitsSchemeType.schemeType.rawValue
        components.host = url.fruitsUrl()
        switch payload.apiParameterEventType?.getType() {
        case FruitsEventType.event_FruitsList.rawValue:
            components.path = FruitsComponentURLPath.urlPath_FruitsList.rawValue
        default :
            components.path = FruitsComponentURLPath.urlPath__Stats.rawValue
            components.queryItems = [
                URLQueryItem(name: FruitsQueryName.event.rawValue, value: payload.apiParameterEventType?.getType()),
                URLQueryItem(name: FruitsQueryName.data.rawValue, value: payload.apiParameterEventData)
            ]
        }
        
        self.url = components.url
    }
    fileprivate mutating func addHeader(name: String, value: String) {
        headers?[name] = value
    }
}


enum FruitsEventType: String {
    case event_load = "load"
    case event_display = "display"
    case event_error = "error"
    case event_FruitsList =  "FruitsList"
    
    func getType() -> String {
        switch self{
        case .event_load: return FruitsEventType.event_load.rawValue
        case .event_display: return FruitsEventType.event_display.rawValue
        case .event_error: return FruitsEventType.event_error.rawValue
        case .event_FruitsList: return FruitsEventType.event_FruitsList.rawValue
        }
    }
    
}

enum FruitsComponentURLPath: String {
  case urlPath_FruitsList = "/fmtvp/recruit-test-data/master/data.json"
  case urlPath__Stats = "/fmtvp/recruit-test-data/master/stats"
}

enum FruitsSchemeType: String{
    case schemeType  = "https"
}

enum FruitsQueryName: String{
    case event  = "event"
    case data = "data"
}

enum FruitsHTTPMimeType: String {
    case applicationJSON = "application/json; charset=utf-8"
}

enum FruitsHTTPHeaderType: String{
    case contentType    = "Content-Type"
}

enum FruitsHTTPMethod: String {
    case get
    case post
}

enum FruitsHTTPPayloadType{
    case requestMethodGET
    case requestMethodPOST
    func httpMethod() -> String {
        switch self{
        case .requestMethodGET: return FruitsHTTPMethod.get.rawValue
        case .requestMethodPOST: return FruitsHTTPMethod.post.rawValue
        }
    }
}

struct FruitsAPIModule:FruitsAPIModuleProtocol {
    var payloadType: FruitsHTTPPayloadType?
    var apiParameterEventType: FruitsEventType?
    var apiParameterEventData:String?
    var fruitsUrl: FruitsHTTPSUrl?
}


protocol FruitsAPIModuleProtocol {
    var payloadType: FruitsHTTPPayloadType? {get set}
    var apiParameterEventType: FruitsEventType? {get set}
    var apiParameterEventData:String? {get set}
    var fruitsUrl: FruitsHTTPSUrl? {get set}
}

enum FruitsURL:String {
    case fruitsUrl = "raw.githubusercontent.com"
}

enum FruitsHTTPSUrl: String {
    case fruitsHTTPSUrl
    func fruitsUrl() -> String {
        switch self {
        case .fruitsHTTPSUrl: return FruitsURL.fruitsUrl.rawValue
        }
    }
}
