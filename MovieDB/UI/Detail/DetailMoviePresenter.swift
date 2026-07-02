
//  DetailMoviePresenter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

class DetailMoviePresenter: DetailMovieRouterToPresenter {
    
    weak var view: DetailMoviePresenterToView?
    var interactor: DetailMoviePresenterToInteractor?
    var router: DetailMoviePresenterToRouter?
    
    private let movieId: Int
    private let imageURLBuilder: ImageURLBuilder

    private let reviewLimit = 4

    init(
        view: DetailMoviePresenterToView,
        interactor: DetailMoviePresenterToInteractor?,
        router: DetailMoviePresenterToRouter?,
        movieId: Int,
        imageURLBuilder: ImageURLBuilder
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movieId = movieId
        self.imageURLBuilder = imageURLBuilder
    }
}

// MARK: - Stub View
extension DetailMoviePresenter: DetailMovieViewToPresenter {
    func viewDidLoad() {
        interactor?.getMovieDetail(movieId: movieId)
        interactor?.getReviews(movieId: movieId, page: 1)
    }

    func didTapSeeAllReviews() {
        router?.showAllReviews(vc: view, movieId: movieId)
    }
}

// MARK: - Stub Interactor
extension DetailMoviePresenter: DetailMovieInteractorToPresenter {
    func didLoadDetail(_ detail: MovieDetailEntity) {
        view?.configure(with: makeDisplayModel(from: detail))
    }

    func didFailLoadDetail(message: String) {
        print(message)
    }

    func didLoadReviews(_ page: ReviewPageEntity) {
        let reviews = page.reviews.prefix(reviewLimit).map { ReviewItem($0) }
        let hasMore = page.totalResults > reviewLimit
        view?.showReviews(reviews, hasMore: hasMore)
    }

    func didFailLoadReviews(message: String) {
        print(message)
        view?.showReviews([], hasMore: false)
    }
}

// MARK: - Mapping
private extension DetailMoviePresenter {
    func makeDisplayModel(from detail: MovieDetailEntity) -> DetailMovieEntity.Movie {
        DetailMovieEntity.Movie(
            title: detail.title,
            overview: detail.overview,
            ratingText: makeRatingText(average: detail.voteAverage, count: detail.voteCount),
            backdropURL: imageURLBuilder.url(path: detail.backdropPath, size: .backdrop)
        )
    }

    func makeRatingText(average: Double?, count: Int?) -> String? {
        let rating = average?.toRatingText ?? "Not Yet Rated"
        guard let count, count > 0 else { return rating }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let votes = formatter.string(from: NSNumber(value: count)) ?? "\(count)"
        return "\(rating)  ·  \(votes) votes"
    }
}
