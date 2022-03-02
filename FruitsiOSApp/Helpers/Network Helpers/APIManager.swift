//
//  APIManager.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation
import UIKit

/// Network status
enum ReachabilityStatus {
    case unknown
    case disconnected
    case connected
}

protocol APIServiceProtocol : AnyObject {
    var urlSession: URLSessionProtocol { get }
}

///  API manager class to handle the API calls
final class APIManager: APIServiceProtocol {
    /// URLSession used for query
    var urlSession: URLSessionProtocol
    /// Data Task
    private var task: URLSessionDataTask?
    // Reachability to check the internet
    private let reachabilityManager: NetworkReachabilityManager?
    private(set) var reachabilityStatus: ReachabilityStatus
    /**
     Init kit
     - Parameter urlSession: URLSession used for query
     */
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
        self.reachabilityManager = NetworkReachabilityManager()
        self.reachabilityStatus = .unknown
        beginListeningNetworkReachability()
    }
    
    deinit {
        reachabilityManager?.stopListening()
    }
    
    /**
     Reachability
     
     - Start the reachability
     - To checek network status
     */
    private func beginListeningNetworkReachability() {
        reachabilityManager?.listener = { status in
            switch status {
            case .unknown: self.reachabilityStatus = .unknown
            case .notReachable:
                self.reachabilityStatus = .disconnected
                self.showErrorForNoNetwork()
            case .reachable(.ethernetOrWiFi), .reachable(.wwan): self.reachabilityStatus = .connected
            }
        }
        reachabilityManager?.startListening()
    }
    /**
     Show Alert message on no network connection
     */
    private func showErrorForNoNetwork()  {
        task?.suspend()
        DispatchQueue.main.async {
            AlertViewController.showAlert(withTitle: "Alert", message: "No Internet Connection")
        }
    }
    /// init Kit
     convenience init() {
        self.init(urlSession: URLSession.shared)
    }
    
    /**
      Send API Request
     **/
    private func sendRequest<T: Codable>(payload: FruitsHTTPPayloadProtocol?, completion: @escaping (Result<T, Error>) -> Void)  {
        
        let (urlRequest,error) = self.prepareRequest(withPayload: payload)
        if error != nil  {
            completion(.failure(error!))
            return
        }
        guard let urlRequest = urlRequest else {
            completion(.failure(NetworkRequestResponseState.invalidRequestHeader))
            return
        }
        
        task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            self?.jsonDecoder(data: data ?? nil, response: response ?? nil, completion: completion)
        }
        task?.resume()
    }

}

/// APIManager Protocol
protocol APIManagerProtocol : AnyObject {
    func getFruitsInfo(payload: FruitsHTTPPayloadProtocol?,completion: @escaping (Result<FruitResponseModel, Error>) -> Void)
    func getFruitsStatusInfo(payload: FruitsHTTPPayloadProtocol?, completion: @escaping (Result<Int, Error>) -> Void)
}

extension APIManager: APIManagerProtocol {
    /**
     Retrieve the Fruits list
     - Parameter id:  Payload protocol, containing payload data
     - Parameter completion: Result of api call
     */
    func getFruitsInfo(payload: FruitsHTTPPayloadProtocol?, completion: @escaping (Result<FruitResponseModel, Error>) -> Void){
        sendRequest(payload: payload,completion: completion)
    }
    
    func getFruitsStatusInfo(payload: FruitsHTTPPayloadProtocol?, completion: @escaping (Result<Int, Error>) -> Void){
        sendRequest(payload: payload,completion: completion)
    }
}





