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
    weak var navigator: Navigator?
    
    init(repository: MovieRepository, imageBaseURL: String) {
        self.repository = repository
        self.imageBaseURL = imageBaseURL
    }
    
    func createListMovieScreen() -> UIViewController {
        let view: UIViewController & ListMoviePresenterToView = ListMovieView()
        let router = ListMovieRouter()
        let interactor: ListMoviePresenterToInteractor = ListMovieInteractor(repository: repository)
        
        let presenter = ListMoviePresenter(
            view: view,
            interactor: interactor,
            router: router,
            imageBaseURL: imageBaseURL
        )
        
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
            view: view,
            interactor: interactor,
            router: router,
            movieId: movieId,
            imageBaseURL: imageBaseURL
        )
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
}
