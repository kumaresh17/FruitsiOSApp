//
//  ApiManager+PrepareRequest.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 28/02/2022.
//

import Foundation

extension APIManager {
    /**
       -  Check and Prepare the request URL with the payload data 
     */
     func prepareRequest(withPayload payload:FruitsHTTPPayloadProtocol?) -> (URLRequest?,NetworkRequestResponseState?) {
         
        var urlRequest:URLRequest?
         guard let payload = payload else {
             return (nil,(NetworkRequestResponseState.invalidPayload))
         }

        if let requestUrl =  payload.url {
            urlRequest = URLRequest(url: requestUrl)
            guard let headers = payload.headers else {
                return (nil,(NetworkRequestResponseState.invalidRequestHeader))}
            
            guard var urlRequest = urlRequest else {
                return (nil,(NetworkRequestResponseState.invalidRequest))}
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            urlRequest.httpMethod = payload.type?.httpMethod()
            return (urlRequest,nil)
        } else {
            return (nil,(NetworkRequestResponseState.invalidURL))
        }
    }
}
