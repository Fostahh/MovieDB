
//  ListMovieProtocols.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit
import MovieDBDataLayer

protocol ListMoviePresenterToView: AnyObject {
    var presenter: ListMovieViewToPresenter? { get set }
    
    func renderGenreState(_ state: GenreUIState)
    func renderMovieState(_ state: MovieUIState)
    func showNoMoreMovies()
    func showError(_ message: String)
    func showLoadingFooter()
    func hideLoadingFooter()
}

protocol ListMoviePresenterToInteractor: AnyObject {
    var presenter: ListMovieInteractorToPresenter? { get set }
    
    func fetchGenres()
    func fetchMovies(genreId: Int?)
    func fetchMoreMovies()
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
    func didSelectGenre(at row: Int)
    func didSelectMovie(at row: Int)
    func fetchMoreMoviesIfNeeded(currentRow: Int)
    func cellForItemAt(_ index: Int) -> GenreCellUIState
    func cellForRowAt(_ index: Int) -> MovieCellUIState
    func refreshGenre()
    func refreshMovie()
}

protocol ListMovieInteractorToPresenter: AnyObject {
    var interactor: ListMoviePresenterToInteractor? { get set }
    
    func didSucceedFetchGenres(genres: [GenreEntity])
    func didFailedFetchGenres(message: String)
    func didSucceedFetchMovies(movies: [MovieEntity], isNewGenre: Bool)
    func didFailedFetchMovies(message: String)
    func didReachEndOfMovies()
}

protocol ListMovieRouterToPresenter: AnyObject {
    var router: ListMoviePresenterToRouter? { get set }
    
}

