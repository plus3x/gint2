//
//  GitHubReposytoryService.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import UIKit

protocol GitHubRepositoryProvider {
    @discardableResult func repositories(offset: Int?, completion: @escaping ResultHandler<[Repository]>) -> URLSessionTask?
}

class GitHubReposytoryService: GitHubRepositoryProvider {
    private let repositoriesPath = "/user/repos"
    
    @discardableResult func repositories(offset: Int? = nil, completion: @escaping ResultHandler<[Repository]>) -> URLSessionTask? {
        let offset: Int = offset ?? 0
        let perPage = 25
        let page = Int(offset / perPage) + 1
        let path = repositoriesPath + "?page=\(page)&per_page=\(perPage)"

        let task = GitHubService.request(path) { result in
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
        
        return task
    }
}
