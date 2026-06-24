//
//  RemoteDataSource.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation

protocol RemoteDataSource {
    func getMovies() async throws -> MoviesResponse
}

final class RemoteDataSourceImpl: RemoteDataSource {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getMovies() async throws -> MoviesResponse {
        try await networkManager.request(Endpoints.Gets.movie)
    }
}
