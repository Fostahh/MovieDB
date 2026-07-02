
//  DetailMovieView.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit
import Kingfisher

final class DetailMovieView: UIViewController {

    var presenter: DetailMovieViewToPresenter?

    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var reviewsTitleLabel: UILabel!
    @IBOutlet weak var reviewsStackView: UIStackView!
    @IBOutlet weak var seeAllReviewsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSeeAllReviews()
        presenter?.viewDidLoad()
    }

    private func setupSeeAllReviews() {
        seeAllReviewsLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapSeeAllReviews))
        seeAllReviewsLabel.addGestureRecognizer(tap)
    }

    @objc private func didTapSeeAllReviews() {
        presenter?.didTapSeeAllReviews()
    }
}

extension DetailMovieView: DetailMoviePresenterToView {
    func configure(with movie: DetailMovieEntity.Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = movie.ratingText
        overviewLabel.text = movie.overview

        if let url = movie.backdropURL {
            backdropImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "film"),
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else {
            backdropImageView.image = UIImage(systemName: "film")
        }
    }

    func showError(_ message: String) {
        Toast.showMessage(message, type: .error)
    }

    func showReviews(_ reviews: [ReviewItem], hasMore: Bool) {
        reviewsStackView.arrangedSubviews.forEach {
            reviewsStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let isEmpty = reviews.isEmpty
        reviewsTitleLabel.isHidden = isEmpty
        reviewsStackView.isHidden = isEmpty
        seeAllReviewsLabel.isHidden = isEmpty || !hasMore

        for review in reviews {
            let reviewView = ReviewView()
            reviewView.configure(with: review, contentLineLimit: 4)
            reviewsStackView.addArrangedSubview(reviewView)
        }
    }
}
