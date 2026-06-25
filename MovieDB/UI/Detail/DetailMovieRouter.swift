
//  DetailMovieRouter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit

final class DetailMovieRouter: DetailMoviePresenterToRouter {

    weak var presenter: DetailMovieRouterToPresenter?
    weak var navigator: Navigator?

    func showAllReviews(vc: DetailMoviePresenterToView?, movieId: Int) {
        guard let viewController = vc as? UIViewController else { return }
        navigator?.navigateToListReviewScreen(viewController, movieId: movieId)
    }
}
