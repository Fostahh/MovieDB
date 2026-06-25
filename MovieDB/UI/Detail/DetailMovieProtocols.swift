
//  DetailMovieProtocols.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit
import MovieDBDataLayer

protocol DetailMoviePresenterToView: AnyObject {
    var presenter: DetailMovieViewToPresenter? { get set }

    func configure(with movie: DetailMovieEntity.Movie)
    func showReviews(_ reviews: [ReviewItem], hasMore: Bool)
}

protocol DetailMoviePresenterToInteractor: AnyObject {
    var presenter: DetailMovieInteractorToPresenter? { get set }

    func getMovieDetail(movieId: Int)
    func getReviews(movieId: Int, page: Int)
}

protocol DetailMoviePresenterToRouter: AnyObject {
    var presenter: DetailMovieRouterToPresenter? { get set }
    var navigator: Navigator? { get set }

    func showAllReviews(vc: DetailMoviePresenterToView?, movieId: Int)
}

protocol DetailMovieViewToPresenter: AnyObject {
    var view: DetailMoviePresenterToView? { get set }

    func viewDidLoad()
    func didTapSeeAllReviews()
}

protocol DetailMovieInteractorToPresenter: AnyObject {
    var interactor: DetailMoviePresenterToInteractor? { get set }

    func didLoadDetail(_ detail: MovieDetailEntity)
    func didFailLoadDetail(message: String)
    func didLoadReviews(_ page: ReviewPageEntity)
    func didFailLoadReviews(message: String)
}

protocol DetailMovieRouterToPresenter: AnyObject {
    var router: DetailMoviePresenterToRouter? { get set }
}
