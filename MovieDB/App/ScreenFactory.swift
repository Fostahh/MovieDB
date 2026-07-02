//
//  ScreenFactory.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit
import MovieDBDataLayer

class ScreenFactory {

    private let repository: MovieRepository
    private let imageURLBuilder: ImageURLBuilder
    weak var navigator: Navigator?

    init(repository: MovieRepository, imageBaseURL: String) {
        self.repository = repository
        self.imageURLBuilder = ImageURLBuilder(baseURL: imageBaseURL)
    }

    func createListMovieScreen() -> UIViewController {
        let view: UIViewController & ListMoviePresenterToView = ListMovieView()
        let router = ListMovieRouter()
        let interactor: ListMoviePresenterToInteractor = ListMovieInteractor(repository: repository)

        let presenter = ListMoviePresenter(imageURLBuilder: imageURLBuilder)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.navigator = navigator

        return view
    }

    func createDetailMovieScreen(movieId: Int) -> UIViewController {
        let view: UIViewController & DetailMoviePresenterToView = DetailMovieView()
        let router = DetailMovieRouter()
        let interactor: DetailMoviePresenterToInteractor = DetailMovieInteractor(repository: repository)

        let presenter = DetailMoviePresenter(
            movieId: movieId,
            imageURLBuilder: imageURLBuilder
        )
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.navigator = navigator

        return view
    }

    func createListReviewScreen(movieId: Int) -> UIViewController {
        let view: UIViewController & ListReviewPresenterToView = ListReviewView()
        let router = ListReviewRouter()
        let interactor: ListReviewPresenterToInteractor = ListReviewInteractor(repository: repository, movieId: movieId)

        let presenter = ListReviewPresenter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.navigator = navigator

        return view
    }
}
