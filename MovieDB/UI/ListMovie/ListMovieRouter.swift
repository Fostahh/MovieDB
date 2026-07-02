
//  ListMovieRouter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit

final class ListMovieRouter: ListMoviePresenterToRouter {
    weak var presenter: ListMovieRouterToPresenter?
    weak var navigator: Navigator?
    
    func showDetail(_ view: ListMoviePresenterToView?, movieId: Int) {
        guard let vc = view as? UIViewController else { return }
        navigator?.navigateToDetailScreen(vc, movieId: movieId)
    }
}
