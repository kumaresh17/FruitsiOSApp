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
            completion(.failure(NetworkError.responseError))
            return }
        guard let data = data else {
            completion(.failure(NetworkError.noDataFound))
            return }
        if data.isInValid()  {
            completion(.failure(NetworkError.inValidData))
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
