
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
    private let imageBaseURL: String
    
    private static let previewReviewLimit = 4
    
    init(
        view: DetailMoviePresenterToView,
        interactor: DetailMoviePresenterToInteractor?,
        router: DetailMoviePresenterToRouter?,
        movieId: Int,
        imageBaseURL: String
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.movieId = movieId
        self.imageBaseURL = imageBaseURL
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
        let items = page.reviews.prefix(Self.previewReviewLimit).map(makeReviewItem)
        let hasMore = page.totalResults > Self.previewReviewLimit
        view?.showReviews(Array(items), hasMore: hasMore)
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
            backdropURL: makeBackdropURL(path: detail.backdropPath)
        )
    }

    func makeReviewItem(from review: ReviewEntity) -> ReviewItem {
        ReviewItem(
            author: review.author ?? "Anonymous",
            content: review.content ?? "",
            ratingText: makeReviewRatingText(review.rating),
            dateText: makeDateText(review.createdAt)
        )
    }

    func makeRatingText(average: Double?, count: Int?) -> String? {
        guard let average, average > 0 else { return "Not yet rated" }
        let rating = String(format: "★ %.1f", average)
        guard let count, count > 0 else { return rating }
        let votes = Self.decimalFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
        return "\(rating)  ·  \(votes) votes"
    }

    func makeReviewRatingText(_ rating: Double?) -> String? {
        guard let rating, rating > 0 else { return nil }
        return String(format: "★ %.1f", rating)
    }

    func makeDateText(_ isoString: String?) -> String? {
        guard let isoString, let date = Self.isoFormatter.date(from: isoString) else { return nil }
        return Self.displayDateFormatter.string(from: date)
    }

    func makeBackdropURL(path: String?) -> URL? {
        guard let path else { return nil }
        return URL(string: "\(imageBaseURL)/w780\(path)")
    }

    static let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
