//
//  GitHubService.swift
//  Gint
//
//  Created by Vladislav Petrov on 08/10/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

enum FailrureResult: Error {
    case invalidData
    case unknownError(error: Error)
    case badResponse
    case authenticationError
}

typealias ResultHandler<T> = (Result<T, FailrureResult>) -> Void

struct GitHubService {
    static var token: String? { return Environment.GitHub.token }
    private static let apiURL = "https://api.github.com"
    private static var session: URLSession? {
        guard let token = GitHubService.token else { return nil }
        
        let configuration = URLSessionConfiguration.default

        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)

        return session
    }
    
    @discardableResult static func request(_ path: String,
                                           method: URLRequest.HTTPMethod = .get,
                                           body: Data? = nil,
                                           completion: @escaping ResultHandler<Data>) -> URLSessionTask? {
        guard let session = session else {
            completion(.failure(.authenticationError))
            return nil
        }
        
        let url = URL(string: apiURL + path)! // swiftlint:disable:this force_unwrapping
        let request = URLRequest(url: url).method(method).body(body)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
            
        task.resume()
        
        return task
    }
}
