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
    private let imageBaseURL: String

    init(repository: MovieRepository, imageBaseURL: String) {
        self.repository = repository
        self.imageBaseURL = imageBaseURL
    }

    func createListMovieScreen() -> UIViewController {
        let view: UIViewController & ListMoviePresenterToView = ListMovieView()
        let router: ListMoviePresenterToRouter = ListMovieRouter()
        let interactor: ListMoviePresenterToInteractor = ListMovieInteractor(repository: repository)
        
        let presenter: ListMovieViewToPresenter & ListMovieInteractorToPresenter & ListMovieRouterToPresenter = ListMoviePresenter(
            view: view,
            interactor: interactor,
            router: router,
            imageBaseURL: imageBaseURL
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
}
