
//  ListReviewInteractor.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

final class ListReviewInteractor: ListReviewPresenterToInteractor {
    
    weak var presenter: ListReviewInteractorToPresenter?
    
    private let repository: MovieRepository
    private let movieId: Int
    private var fetchTask: Task<Void, Never>?
    
    private let paginator = Paginator()
    
    init(repository: MovieRepository, movieId: Int) {
        self.repository = repository
        self.movieId = movieId
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    func loadReviews() {
        fetchTask?.cancel()
        paginator.reset()
        fetchReviews()
    }
    
    func loadMoreReviews() {
        guard paginator.hasMorePages else { return }
        fetchReviews()
    }
    
    private func fetchReviews() {
        guard let pageToFetch = paginator.beginFetch() else { return }
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await repository.getReviews(movieId: movieId, page: pageToFetch)
                paginator.completeFetch(fetchedPage: pageToFetch, totalPages: result.totalPages)
                presenter?.didLoadReviews(result.reviews)
            } catch {
                paginator.failFetch()
                presenter?.didFailLoadReviews(message: error.displayMessage)
            }
        }
    }
}
