
//  ListMovieProtocols.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit
import MovieDBDataLayer

protocol ListMoviePresenterToView: AnyObject {
    var presenter: ListMovieViewToPresenter? { get set }
    
    func reloadData()
}

protocol ListMoviePresenterToInteractor: AnyObject {
    var presenter: ListMovieInteractorToPresenter? { get set }
    
    func getDiscoverMovies()    
}

protocol ListMoviePresenterToRouter: AnyObject {
    var presenter: ListMovieRouterToPresenter? { get set }

    // TODO: 
}

protocol ListMovieViewToPresenter: AnyObject {
    var view: ListMoviePresenterToView? { get set }
    var numberOfMovies: Int { get }
     
    func viewDidLoad()
    func getMovie(at row: Int) -> ListMovieEntity.Movie
    func loadMoreIfNeeded(currentRow: Int)
}

protocol ListMovieInteractorToPresenter: AnyObject {
    var interactor: ListMoviePresenterToInteractor? { get set }
    
    func didSucceed(movies: [MovieEntity])
    func didFailed(message: String)
}

protocol ListMovieRouterToPresenter: AnyObject {
    var router: ListMoviePresenterToRouter? { get set }
    
}

