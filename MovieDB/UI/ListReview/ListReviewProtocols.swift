
//  ListReviewProtocols.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit
import MovieDBDataLayer

protocol ListReviewPresenterToView: AnyObject {
    var presenter: ListReviewViewToPresenter? { get set }
    
    func reloadData()
    func showError(_ message: String)
}

protocol ListReviewPresenterToInteractor: AnyObject {
    var presenter: ListReviewInteractorToPresenter? { get set }
    
    func loadReviews()
    func loadMoreReviews()
}

protocol ListReviewPresenterToRouter: AnyObject {
    var presenter: ListReviewRouterToPresenter? { get set }
    var navigator: Navigator? { get set }
}

protocol ListReviewViewToPresenter: AnyObject {
    var view: ListReviewPresenterToView? { get set }
    var numberOfReviews: Int { get }
    
    func viewDidLoad()
    func getReview(at row: Int) -> ReviewItem
    func loadMoreIfNeeded(currentRow: Int)
}

protocol ListReviewInteractorToPresenter: AnyObject {
    var interactor: ListReviewPresenterToInteractor? { get set }
    
    func didLoadReviews(_ reviews: [ReviewEntity])
    func didFailLoadReviews(message: String)
}

protocol ListReviewRouterToPresenter: AnyObject {
    var router: ListReviewPresenterToRouter? { get set }
}
