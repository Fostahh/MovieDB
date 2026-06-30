
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
    private var genresTask: Task<Void, Never>?
    private var moviesTask: Task<Void, Never>?
    
    private var page: Int = 1
    private var totalPages: Int = 1
    private var isFetching: Bool = false
    private var selectedGenreId: Int?
    private var trackRequestedGenreId: Int = 0
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    deinit {
        genresTask?.cancel()
        moviesTask?.cancel()
    }
    
    func fetchGenres() {
        genresTask?.cancel()
        genresTask = Task { [weak self] in
            guard let self else { return }
            do {
                let genres = try await repository.getGenres()
                presenter?.didSucceedFetchGenres(genres: genres)
            } catch {
                guard let networkError = error as? NetworkError else {
                    presenter?.didFailedFetchGenres(message: error.localizedDescription)
                    return
                }
                presenter?.didFailedFetchGenres(message: networkError.errorMessage)
            }
        }
    }
    
    func fetchMovies(genreId: Int?) {
        moviesTask?.cancel()
        selectedGenreId = genreId
        page = 1
        totalPages = 1
        isFetching = false
        trackRequestedGenreId += 1
        fetchMovies(isNewGenre: true)
    }
    
    func fetchMoreMovies() {
        guard page <= totalPages else {
            presenter?.didReachEndOfMovies()
            return
        }
        fetchMovies(isNewGenre: false)
    }
    
    private func fetchMovies(isNewGenre: Bool) {
        guard !isFetching else { return }
        isFetching = true
        let counter = trackRequestedGenreId
        
        moviesTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await repository.getMovies(page: page, genreId: selectedGenreId)
                guard counter == trackRequestedGenreId else { return }
                page += 1
                totalPages = result.totalPages
                isFetching = false
                presenter?.didSucceedFetchMovies(movies: result.movies, isNewGenre: isNewGenre)
            } catch {
                guard counter == trackRequestedGenreId else { return }
                isFetching = false
                let message = (error as? NetworkError)?.errorMessage ?? error.localizedDescription
                presenter?.didFailedFetchMovies(message: message)
            }
        }
    }
    
}
