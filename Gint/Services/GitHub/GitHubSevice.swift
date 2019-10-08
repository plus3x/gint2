//
//  GitHubSevice.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

enum FailrureResult: Error {
    case invalidData
    case unknownError(error: Error)
    case badResponse
}

typealias ResultHandler<T> = (Result<T, FailrureResult>) -> Void

protocol GitHubSeviceProtocol {
    static var token: String? { get }
    var apiURL: String { get }
    var repositoriesPath: String { get }
    var session: URLSession { get }
    
    func request(_ path: String, method: URLRequest.HTTPMethod, body: Data?, completion: @escaping ResultHandler<Data>)
}

protocol GitHubRepositoryProvider: GitHubSeviceProtocol {
    func repositories(offset: Int?, completion: @escaping (Result<[Repository], FailrureResult>) -> Void)
}

class GitHubService: GitHubSeviceProtocol {
    static var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "UserToken")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "UserToken")
            UserDefaults.standard.synchronize()
        }
    }
    let apiURL = "https://api.github.com"
    let repositoriesPath = "/user/repos"
    var session: URLSession {
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        return session
    }
    
    func request(_ path: String, method: URLRequest.HTTPMethod = .get, body: Data? = nil, completion: @escaping (Result<Data, FailrureResult>) -> Void) {
        guard let token = GitHubService.token else { fatalError("User doesn't logged in!") }
        
        let url = URL(string: apiURL + path)! // swiftlint:disable:this force_unwrapping
        let request = URLRequest(url: url).authorize(with: token).method(method).body(body)
        
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
    }
}

extension GitHubService: GitHubRepositoryProvider {
    func repositories(offset: Int? = nil, completion: @escaping (Result<[Repository], FailrureResult>) -> Void) {
        let offset: Int = offset ?? 0
        let perPage = 25
        let page = Int(offset / perPage) + 1
        let path = repositoriesPath + "?page=\(page)&per_page=\(perPage)"
        
        request(path) { result in
            switch result {
            case .success(let data):
                if let repositories = try? JSONDecoder().decode([Repository].self, from: data) {
                    completion(.success(repositories))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
