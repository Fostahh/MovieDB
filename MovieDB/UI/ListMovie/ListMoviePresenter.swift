
//  ListMoviePresenter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation
import MovieDBDataLayer

typealias GenreUIState = ListMoviePresenter.GenreState
typealias MovieUIState = ListMoviePresenter.MovieState
typealias GenreCellUIState = ListMoviePresenter.GenreCellState
typealias MovieCellUIState = ListMoviePresenter.MovieCellState

final class ListMoviePresenter: ListMovieRouterToPresenter {
    
    enum GenreState: Equatable {
        case success
        case loading
        case error(message: String)
    }
    
    enum MovieState: Equatable {
        case success
        case empty
        case loading
        case error(message: String)
    }
    
    enum GenreCellState {
        case success(genre: ListMovieEntity.Genre)
        case loading
    }
    
    enum MovieCellState {
        case success(movie: ListMovieEntity.Movie)
        case loading
    }
    
    private var genreState: GenreState = .loading {
        didSet { view?.renderGenreState(genreState) }
    }
    
    private var movieState: MovieState = .loading {
        didSet { view?.renderMovieState(movieState) }
    }
    
    private var movies: [ListMovieEntity.Movie] = []
    var numberOfMovies: Int {
        switch movieState {
        case .success: movies.count
        case .loading: Constant.skeletonMovie
        case .empty, .error: .zero
        }
    }
    
    private var genres: [ListMovieEntity.Genre] = []
    var numberOfGenres: Int {
        switch genreState {
        case .success: genres.count
        case .loading: Constant.skeletonGenre
        case .error: .zero
        }
    }
    
    private var selectedGenre = ListMovieEntity.Genre(id: nil, name: Constant.genreAll)
    private var hasReachedEnd = false
    
    weak var view: ListMoviePresenterToView?
    var interactor: ListMoviePresenterToInteractor?
    var router: ListMoviePresenterToRouter?
    
    private let imageURLBuilder: ImageURLBuilder
    init(imageURLBuilder: ImageURLBuilder) {
        self.imageURLBuilder = imageURLBuilder
    }
    
    func viewDidLoad() {
        fetchGenres()
        fetchMovies()
    }
    
    private func fetchGenres() {
        genreState = .loading
        interactor?.fetchGenres()
    }
    
    private func fetchMovies() {
        hasReachedEnd = false
        movieState = .loading
        interactor?.fetchMovies(genreId: selectedGenre.id)
    }
}

// MARK: - Stub Interactor
extension ListMoviePresenter: ListMovieInteractorToPresenter {
    func didSucceedFetchGenres(genres: [GenreEntity]) {
        let mapped = genres.compactMap { entity -> ListMovieEntity.Genre? in
            guard let id = entity.id, let name = entity.name else { return nil }
            return ListMovieEntity.Genre(id: id, name: name)
        }
        self.genres = [selectedGenre] + mapped
        genreState = .success
    }
    
    func didFailedFetchGenres(message: String) {
        genreState = .error(message: message)
    }
    
    func didSucceedFetchMovies(movies: [MovieEntity], isNewGenre: Bool) {
        let mapped = movies.map {
            ListMovieEntity.Movie(
                id: $0.id,
                voteCount: $0.voteCount,
                title: $0.title,
                overview: $0.overview,
                popularity: $0.popularity,
                voteAverage: $0.voteAverage,
                releaseDate: $0.releaseDate,
                posterPathURL: imageURLBuilder.url(path: $0.posterPath, size: .poster)
            )
        }
        
        if isNewGenre {
            self.movies = mapped
        } else {
            self.movies.append(contentsOf: mapped)
        }
        view?.hideLoadingFooter()
        movieState = self.movies.isEmpty ? .empty : .success
    }

    func didFailedFetchMovies(message: String) {
        view?.hideLoadingFooter()
        if movies.isEmpty {
            movieState = .error(message: message)
        } else {
            view?.showError(message)
        }
    }
    
    func didReachEndOfMovies() {
        hasReachedEnd = true
        view?.showNoMoreMovies()
        view?.hideLoadingFooter()
    }
}

// MARK: - Stub View
extension ListMoviePresenter: ListMovieViewToPresenter {
    func didSelectGenre(at row: Int) {
        guard genreState == .success else { return }
        let genre = genres[row]
        guard genre != selectedGenre else { return }
        selectedGenre = genre
        movies = []
        fetchMovies()
    }
    
    func didSelectMovie(at row: Int) {
        guard movieState == .success, let id = movies[row].id else {
            return
        }
        router?.showDetail(view, movieId: id)
    }
    
    func fetchMoreMoviesIfNeeded(currentRow: Int) {
        guard movieState == .success, !hasReachedEnd,
        currentRow >= movies.count - Constant.movieFetchThreshold else { return }
        view?.showLoadingFooter()
        interactor?.fetchMoreMovies()
    }
    
    func cellForItemAt(_ index: Int) -> GenreCellUIState {
        genreState == .success ? .success(genre: genres[index]) : .loading
    }
    
    func cellForRowAt(_ index: Int) -> MovieCellUIState {
        movieState == .success ? .success(movie: movies[index]) : .loading
    }
    
    func refreshGenre() {
        guard case .error = genreState else { return }
        fetchGenres()
    }
    
    func refreshMovie() {
        guard case .error = movieState else { return }
        fetchMovies()
    }
}
