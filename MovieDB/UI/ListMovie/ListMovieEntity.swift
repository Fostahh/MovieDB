
//  ListMovieEntity.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation

enum ListMovieEntity {
    struct Genre: Equatable {
        let id: Int?
        let name: String
    }
    
    struct Movie {
        let id, voteCount: Int?
        let title, overview: String?
        let popularity, voteAverage: Double?
        let releaseDate: String?
        let posterPathURL: URL?
    }
}
