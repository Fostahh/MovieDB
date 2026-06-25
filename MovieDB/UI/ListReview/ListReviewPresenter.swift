
//  ListReviewPresenter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

class ListReviewPresenter: ListReviewRouterToPresenter {

    weak var view: ListReviewPresenterToView?
    var interactor: ListReviewPresenterToInteractor?
    var router: ListReviewPresenterToRouter?

    private var reviews: [ReviewItem] = []

    var numberOfReviews: Int {
        reviews.count
    }

    init(
        view: ListReviewPresenterToView,
        interactor: ListReviewPresenterToInteractor?,
        router: ListReviewPresenterToRouter?
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - View Output
extension ListReviewPresenter: ListReviewViewToPresenter {
    func viewDidLoad() {
        interactor?.loadReviews()
    }

    func getReview(at row: Int) -> ReviewItem {
        reviews[row]
    }

    func loadMoreIfNeeded(currentRow: Int) {
        guard currentRow >= reviews.count - 3 else { return }
        interactor?.loadMoreReviews()
    }
}

// MARK: - Interactor Output
extension ListReviewPresenter: ListReviewInteractorToPresenter {
    func didLoadReviews(_ reviews: [ReviewEntity]) {
        self.reviews.append(contentsOf: reviews.map { ReviewItem($0) })
        view?.reloadData()
    }

    func didFailLoadReviews(message: String) {
        print(message)
    }
}
