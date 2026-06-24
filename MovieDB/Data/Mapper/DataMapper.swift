//
//  DataMapper.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

enum DataMapper {
    static func mapMoviesResponseToMoviesEntity(response: MoviesResponse) -> [MovieEntity] {
        response.movies.map {
            MovieEntity(
                id: $0.id,
                adult: $0.adult ?? false
            )
        }
    }
}
