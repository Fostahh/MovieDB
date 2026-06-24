//
//  Repository.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

public protocol MovieRepository {
    func getMovies() async throws -> [MovieEntity]
}

final class MovieRepositoryImpl: MovieRepository {
    private let remoteDataSource: RemoteDataSource

    init(remoteDataSource: RemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getMovies() async throws -> [MovieEntity] {
        try await DataMapper.mapMoviesResponseToMoviesEntity(
            response: remoteDataSource.getMovies()
        )
    }
}
