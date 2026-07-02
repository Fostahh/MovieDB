//
//  ImageURLBuilder.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 02/07/26.
//

import Foundation

struct ImageURLBuilder {
    
    enum Size: String {
        case poster = "w500"
        case backdrop = "w780"
    }
    
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func url(path: String?, size: Size) -> URL? {
        guard let path else { return nil }
        return URL(string: "\(baseURL)/\(size.rawValue)\(path)")
    }
}
