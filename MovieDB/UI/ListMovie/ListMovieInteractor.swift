
//  ListMovieInteractor.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation
import MovieDBDataLayer

class ListMovieInteractor: ListMoviePresenterToInteractor {

    weak var presenter: ListMovieInteractorToPresenter?
    
    private let repository: MovieRepository
    private var fetchTask: Task<Void, Never>?
    
    private var page: Int = 1
    private var isFetching: Bool = false
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    func getDiscoverMovies() {
        guard !isFetching else {
            return
        }
        isFetching = true
        print("Fetching \(page)")
        fetchTask = Task { [weak self] in
            guard let self else { return }
            defer { isFetching = false }
            do {
                let movies = try await repository.getMovies(page: page)
                page += 1
                presenter?.didSucceed(movies: movies)
            } catch {
                presenter?.didFailed(message: error.localizedDescription)
            }
        }
    }
    
}
