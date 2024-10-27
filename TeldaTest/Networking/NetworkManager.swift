//
//  NetworkManager.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchData<T: Decodable>(from urlString: String,
                                 method: HTTPMethod,
                                 parameters: [String: Any]? = nil,
                                 headers: [String: String]? = nil,
                                 queryItems: [URLQueryItem]? = nil) -> Single<T> {
        return Single.create { single in
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryItems
            
            guard let url = urlComponents?.url else {
                single(.failure(APIError.invalidURL))
                return Disposables.create()
            }
            
            // Map custom HTTPMethodType to Alamofire's HTTPMethod
            let httpMethod: HTTPMethod = (method == .get) ? .get : .post
            let httpHeaders = HTTPHeaders(headers ?? [:]) // Convert dictionary to Alamofire's HTTPHeaders type

            // Perform network request with Alamofire
            let request = AF.request(url, method: httpMethod, parameters: parameters, encoding: JSONEncoding.default, headers: httpHeaders)
                .validate()
                .responseDecodable(of: T.self) { response in
                    print(response)
                    switch response.result {
                    case .success(let data):
                        single(.success(data))
                    case .failure:
                        single(.failure(APIError.requestFailed))
                    }
                }
            
            // Return a disposable to cancel the request if needed
            return Disposables.create { request.cancel() }
        }
    }
}
