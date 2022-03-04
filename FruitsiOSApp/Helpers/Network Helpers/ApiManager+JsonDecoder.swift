//
//  ApiManager+JsonDecoder.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 28/02/2022.
//

import Foundation

extension APIManager {

    /**
       - Check the resposne and data  and if all ok then decode the response data
     */

    func jsonDecoder<T:Codable>(data:Data?,response:URLResponse?,completion:@escaping (Result<T,Error>) -> Void) -> Void {
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            completion(.failure(NetworkRequestResponseState.responseError))
            return }
        guard let data = data else {
            completion(.failure(NetworkRequestResponseState.noDataFound))
            return }
        if data.isEmptyData() {
            completion(.failure(NetworkRequestResponseState.emptyData_SucessResponseCode))/// This case is been handled for usages stats APi which return sucess status code but empty data in response
            return }
        else if data.isInValid()  {
            completion(.failure(NetworkRequestResponseState.inValidData))
            return }
        
        var result: Result<T, Error>
        
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(T.self, from: data)
            result = .success(response)
        } catch let error {
            result = .failure(error)
        }
        completion(result)
    }
    
    
}
