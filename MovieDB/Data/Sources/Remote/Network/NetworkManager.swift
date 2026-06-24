//
//  NetworkManager.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unacceptableStatusCode(Int)
    case decodingFailed(Error)
}

protocol NetworkManager {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkManagerImpl: NetworkManager {
    
    init(
        networkEnvironment: NetworkEnvironment,
        session: URLSession = URLSession.shared
    ) {
        self.networkEnvironment = networkEnvironment
        self.session = session
    }
    
    
    private let networkEnvironment: NetworkEnvironment
    private let session: URLSession
    
    
    private func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(string: networkEnvironment.url + endpoint.path) else {
            throw NetworkError.invalidURL
        }

        let items = endpoint.queryParams
        if !items.isEmpty {
            components.queryItems = items
        }

        guard let compURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: compURL)
        request.setValue("Bearer \(networkEnvironment.authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        return request
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = try makeRequest(for: endpoint)
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.unacceptableStatusCode(http.statusCode)
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
}
