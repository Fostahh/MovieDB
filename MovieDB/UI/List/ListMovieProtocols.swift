
//  ListMovieProtocols.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit
import MovieDBDataLayer

protocol ListMoviePresenterToView: AnyObject {
    var presenter: ListMovieViewToPresenter? { get set }

    func reloadMovies()
    func reloadGenres()
}

protocol ListMoviePresenterToInteractor: AnyObject {
    var presenter: ListMovieInteractorToPresenter? { get set }

    func getGenres()
    func loadMovies(genreId: Int?)
    func loadMoreMovies()
}

protocol ListMoviePresenterToRouter: AnyObject {
    var presenter: ListMovieRouterToPresenter? { get set }
    var navigator: Navigator? { get set }

    func showDetail(_ view: ListMoviePresenterToView?, movieId: Int)
}

protocol ListMovieViewToPresenter: AnyObject {
    var view: ListMoviePresenterToView? { get set }
    var numberOfMovies: Int { get }
    var numberOfGenres: Int { get }

    func viewDidLoad()
    func getMovie(at row: Int) -> ListMovieEntity.Movie
    func getGenre(at row: Int) -> ListMovieEntity.Genre
    func didSelectGenre(at row: Int)
    func didSelectMovie(at row: Int)
    func loadMoreIfNeeded(currentRow: Int)
}

protocol ListMovieInteractorToPresenter: AnyObject {
    var interactor: ListMoviePresenterToInteractor? { get set }

    func didLoadGenres(genres: [GenreEntity])
    func didLoadMovies(movies: [MovieEntity], isNewGenre: Bool)
    func didFailed(message: String)
}

protocol ListMovieRouterToPresenter: AnyObject {
    var router: ListMoviePresenterToRouter? { get set }
    
}

