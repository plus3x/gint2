//
//  URLRequest.swift
//  Gint
//
//  Created by Vladislav Petrov on 27/09/2019.
//  Copyright © 2019 Vladislav Petrov. All rights reserved.
//

import Foundation

extension URLRequest {
    enum HTTPMethod: String {
        case get, post, put, delete, patch, head
    }
    
    func authorize(with token: String) -> URLRequest {
        return header("Authorization", "Bearer \(token)")
    }
    
    func method(_ method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue.uppercased()
        return request
    }
    
    func body(_ data: Data?) -> URLRequest {
        var request = self
        
        request.httpBody = data
        
        return request
    }
    
    func header(_ field: String, _ value: String) -> URLRequest {
        var request = self
        request.setValue(value, forHTTPHeaderField: field)
        return request
    }
}
