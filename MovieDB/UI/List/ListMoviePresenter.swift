
//  ListMoviePresenter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation
import MovieDBDataLayer

class ListMoviePresenter: ListMovieRouterToPresenter {
    
    private let imageBaseURL: String
    private var movies: [ListMovieEntity.Movie] = [] {
        didSet { view?.reloadMovies() }
    }
    private var genres: [ListMovieEntity.Genre] = []
    private var selectedGenre = ListMovieEntity.Genre(id: nil, name: "All")

    var numberOfMovies: Int {
        movies.count
    }

    var numberOfGenres: Int {
        genres.count
    }
    
    weak var view: ListMoviePresenterToView?
    var interactor: ListMoviePresenterToInteractor?
    var router: ListMoviePresenterToRouter?

    init(
        view: ListMoviePresenterToView,
        interactor: ListMoviePresenterToInteractor?,
        router: ListMoviePresenterToRouter?,
        imageBaseURL: String
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.imageBaseURL = imageBaseURL
    }

    func viewDidLoad() {
        interactor?.getGenres()
        interactor?.loadMovies(genreId: selectedGenre.id)
    }
}

// MARK: - Stub Interactor
extension ListMoviePresenter: ListMovieInteractorToPresenter {
    func didLoadGenres(genres: [GenreEntity]) {
        let mapped = genres.compactMap { entity -> ListMovieEntity.Genre? in
            guard let id = entity.id, let name = entity.name else { return nil }
            return ListMovieEntity.Genre(id: id, name: name)
        }
        self.genres = [selectedGenre] + mapped
        view?.reloadGenres()
    }

    func didLoadMovies(movies: [MovieEntity], isNewGenre: Bool) {
        let mapped = movies.map {
            ListMovieEntity.Movie(
                id: $0.id,
                voteCount: $0.voteCount,
                title: $0.title,
                overview: $0.overview,
                popularity: $0.popularity,
                voteAverage: $0.voteAverage,
                posterPath: $0.posterPath,
                releaseDate: $0.releaseDate,
                imageBaseURL: imageBaseURL
            )
        }

        if isNewGenre {
            self.movies = mapped
        } else {
            self.movies.append(contentsOf: mapped)
        }
    }

    func didFailed(message: String) {
        print(message)
    }
}

// MARK: - Stub View
extension ListMoviePresenter: ListMovieViewToPresenter {
    func getMovie(at row: Int) -> ListMovieEntity.Movie {
        movies[row]
    }

    func getGenre(at row: Int) -> ListMovieEntity.Genre {
        genres[row]
    }

    func didSelectGenre(at row: Int) {
        let genre = genres[row]
        guard genre != selectedGenre else { return }
        selectedGenre = genre
        movies = []
        interactor?.loadMovies(genreId: genre.id)
    }

    func didSelectMovie(at row: Int) {
        guard let id = movies[row].id else {
            return
        }
        router?.showDetail(view, movieId: id)
    }

    func loadMoreIfNeeded(currentRow: Int) {
        guard currentRow >= movies.count - 5 else { return }
        interactor?.loadMoreMovies()
    }
}
