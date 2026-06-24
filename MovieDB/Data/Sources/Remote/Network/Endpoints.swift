//
//  Endpoints.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var queryParams: [URLQueryItem] { get }
}

enum Endpoints {
    
    enum Gets: Endpoint {
        case movie
        
        var path: String {
            switch self {
            case .movie: return "/movie/changes"
            }
        }
        
        var queryParams: [URLQueryItem] {
            switch self {
            case .movie: return []
            }
        }
    }
}
