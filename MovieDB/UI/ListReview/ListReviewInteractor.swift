
//  ListReviewInteractor.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

class ListReviewInteractor: ListReviewPresenterToInteractor {

    weak var presenter: ListReviewInteractorToPresenter?

    private let repository: MovieRepository
    private let movieId: Int
    private var fetchTask: Task<Void, Never>?

    private var page: Int = 1
    private var totalPages: Int = 1
    private var isFetching: Bool = false

    init(repository: MovieRepository, movieId: Int) {
        self.repository = repository
        self.movieId = movieId
    }

    deinit {
        fetchTask?.cancel()
    }

    func loadReviews() {
        fetchTask?.cancel()
        page = 1
        totalPages = 1
        isFetching = false
        fetchReviews()
    }

    func loadMoreReviews() {
        guard page <= totalPages else { return }
        fetchReviews()
    }

    private func fetchReviews() {
        guard !isFetching else { return }
        isFetching = true

        let pageToFetch = page
        fetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await repository.getReviews(movieId: movieId, page: pageToFetch)
                totalPages = result.totalPages
                page = pageToFetch + 1
                isFetching = false
                presenter?.didLoadReviews(result.reviews)
            } catch {
                isFetching = false
                presenter?.didFailLoadReviews(message: error.localizedDescription)
            }
        }
    }
}
