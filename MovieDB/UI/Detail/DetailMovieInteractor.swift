
//  DetailMovieInteractor.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

class DetailMovieInteractor: DetailMoviePresenterToInteractor {
    
    weak var presenter: DetailMovieInteractorToPresenter?
    
    private let repository: MovieRepository
    private var detailTask: Task<Void, Never>?
    private var reviewsTask: Task<Void, Never>?
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    deinit {
        detailTask?.cancel()
        reviewsTask?.cancel()
    }
    
    func getMovieDetail(movieId: Int) {
        detailTask = Task { [weak self] in
            guard let self else { return }
            do {
                let detail = try await repository.getMovieDetail(movieId: movieId)
                presenter?.didLoadDetail(detail)
            } catch {
                presenter?.didFailLoadDetail(message: error.localizedDescription)
            }
        }
    }
    
    func getReviews(movieId: Int, page: Int) {
        reviewsTask = Task { [weak self] in
            guard let self else { return }
            do {
                let result = try await repository.getReviews(movieId: movieId, page: page)
                presenter?.didLoadReviews(result)
            } catch {
                presenter?.didFailLoadReviews(message: error.localizedDescription)
            }
        }
    }
}
