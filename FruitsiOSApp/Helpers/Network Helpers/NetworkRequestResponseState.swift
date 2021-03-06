//
//  NetworkRequestResponseState.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation

/**
  - Self defined Network Resquest and response states
 */

enum NetworkRequestResponseState: Error {
    case invalidURL
    case responseError
    case noDataFound
    case inValidData
    case unknown
    case invalidRequestHeader
    case invalidRequest
    case invalidPayload
    case emptyData_SucessResponseCode
}

extension NetworkRequestResponseState: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .invalidPayload:
            return NSLocalizedString("Invalid Payload", comment: "Invalid Payload")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .noDataFound:
            return NSLocalizedString("No fruits data found", comment: "noDataFound error")
        case .inValidData:
            return NSLocalizedString("No fruits data found", comment: "inValidData error")
        case .invalidRequestHeader:
            return NSLocalizedString("InvalidRequestHeader", comment: "InvalidRequestHeader")
        case .invalidRequest:
            return NSLocalizedString("InvalidRequest", comment: "InvalidRequest")
        case .emptyData_SucessResponseCode:
            return NSLocalizedString("EmptyData with valid Success response", comment: "EmptyData")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}

