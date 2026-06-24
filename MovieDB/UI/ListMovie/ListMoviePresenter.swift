
//  ListMoviePresenter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation
import MovieDBDataLayer

class ListMoviePresenter: ListMovieRouterToPresenter {

    weak var view: ListMoviePresenterToView?
    var interactor: ListMoviePresenterToInteractor?
    var router: ListMoviePresenterToRouter?

    private let imageBaseURL: String

    private var movies: [ListMovieEntity.Movie] = [] {
        didSet { view?.reloadData() }
    }

    var numberOfMovies: Int {
        movies.count
    }

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
        interactor?.getDiscoverMovies()
    }
    
}

// MARK: - Stub Interactor
extension ListMoviePresenter: ListMovieInteractorToPresenter {
    func didSucceed(movies: [MovieEntity]) {
        self.movies.append(
            contentsOf: movies.map {
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
        })
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
    
    func loadMoreIfNeeded(currentRow: Int) {
        guard currentRow >= movies.count - 5 else {
            return
        }
        print("Fetch More")
        interactor?.getDiscoverMovies()
    }
}
