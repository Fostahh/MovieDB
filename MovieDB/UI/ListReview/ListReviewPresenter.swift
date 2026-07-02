
//  ListReviewPresenter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

final class ListReviewPresenter: ListReviewRouterToPresenter {
    
    weak var view: ListReviewPresenterToView?
    var interactor: ListReviewPresenterToInteractor?
    var router: ListReviewPresenterToRouter?
    
    private var reviews: [ReviewItem] = []
    
    var numberOfReviews: Int {
        reviews.count
    }
}

// MARK: - Stub View
extension ListReviewPresenter: ListReviewViewToPresenter {
    func viewDidLoad() {
        interactor?.loadReviews()
    }
    
    func getReview(at row: Int) -> ReviewItem {
        reviews[row]
    }
    
    func loadMoreIfNeeded(currentRow: Int) {
        guard currentRow >= reviews.count - Constant.reviewFetchThreshold else { return }
        interactor?.loadMoreReviews()
    }
}

// MARK: - Stub Interactor
extension ListReviewPresenter: ListReviewInteractorToPresenter {
    func didLoadReviews(_ reviews: [ReviewEntity]) {
        self.reviews.append(contentsOf: reviews.map { ReviewItem($0) })
        view?.reloadData()
    }
    
    func didFailLoadReviews(message: String) {
        view?.showError(message)
    }
}
