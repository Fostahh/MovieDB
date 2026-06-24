
//  ListMovieEntity.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation

enum ListMovieEntity {
    struct Movie {
        let id, voteCount: Int?
        let title, overview: String?
        let popularity, voteAverage: Double?
        let posterPath, releaseDate: String?
        let imageBaseURL: String

        var posterPathURL: URL? {
            guard let posterPath else { return nil }
            return URL(string: "\(imageBaseURL)/w500\(posterPath)")
        }
    }
}
