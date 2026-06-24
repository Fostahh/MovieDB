//
//  DataLayerFactory.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

public enum DataLayerFactory {
    public static func makeRepository(apiKey: String, authToken: String, baseURL: String) -> MovieRepository {
        let environment = NetworkEnvironmentImpl(url: baseURL, apiKey: apiKey, authToken: authToken)
        let networkManager = NetworkManagerImpl(networkEnvironment: environment)
        let remoteDataSource = RemoteDataSourceImpl(networkManager: networkManager)
        return MovieRepositoryImpl(remoteDataSource: remoteDataSource)
    }
}

protocol NetworkEnvironment {
    var url: String { get }
    var apiKey: String { get }
    var authToken: String { get }
}

struct NetworkEnvironmentImpl: NetworkEnvironment {
    let url: String
    let apiKey: String
    let authToken: String
}
