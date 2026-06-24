//
//  MoviesResponse.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation

struct MoviesResponse: Codable {
    let movies: [MovieResponse]
    let page, totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieResponse: Codable {
    let id: Int
    let adult: Bool?
}
