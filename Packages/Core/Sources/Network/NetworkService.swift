//
//  NetworkService.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

import Combine
import Configuration
import Foundation

public protocol NetworkServiceProtocol {
    func performRequest<T: Decodable>(with builder: ApiRequestBuilder, decodingType: T.Type) -> Future<T, Error>
}

public final class NetworkService: NetworkServiceProtocol {
    
    public init() { }
    
    public func performRequest<T: Decodable>(
        with builder: ApiRequestBuilder,
        decodingType: T.Type
    ) -> Future<T, Error> {
        return Future { promise in
            var urlString = Environment.baseURL + builder.endpoint.path
            
            if let urlParams = builder.urlParams {
                let queryItems = urlParams.map { URLQueryItem(name: $0.key, value: $0.value) }
                var components = URLComponents(string: urlString)
                components?.queryItems = queryItems
                urlString = components?.url?.absoluteString ?? urlString
            }
            
            guard let url = URL(string: urlString) else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = builder.httpMethod.rawValue
            
            if builder.httpMethod == .post || builder.httpMethod == .put, let payload = builder.payload {
                request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            if let headers = builder.headers {
                for (key, value) in headers {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(URLError(.badServerResponse)))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    promise(.failure(error))
                }
            }.resume()
        }
    }
}
