
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

    private let paginator = Paginator()
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
                presenter?.didFailedFetchGenres(message: error.displayMessage)
            }
        }
    }

    func fetchMovies(genreId: Int?) {
        moviesTask?.cancel()
        selectedGenreId = genreId
        paginator.reset()
        trackRequestedGenreId += 1
        fetchMovies(isNewGenre: true)
    }

    func fetchMoreMovies() {
        guard paginator.hasMorePages else {
            presenter?.didReachEndOfMovies()
            return
        }
        fetchMovies(isNewGenre: false)
    }

    private func fetchMovies(isNewGenre: Bool) {
        guard let pageToFetch = paginator.beginFetch() else { return }
        let counter = trackRequestedGenreId

        moviesTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await repository.getMovies(page: pageToFetch, genreId: selectedGenreId)
                guard counter == trackRequestedGenreId else { return }
                paginator.completeFetch(fetchedPage: pageToFetch, totalPages: result.totalPages)
                presenter?.didSucceedFetchMovies(movies: result.movies, isNewGenre: isNewGenre)
            } catch {
                guard counter == trackRequestedGenreId else { return }
                paginator.failFetch()
                presenter?.didFailedFetchMovies(message: error.displayMessage)
            }
        }
    }
    
}
