//
//  MovieTableViewCell.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit
import Kingfisher

final class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        overviewLabel.numberOfLines = .zero
        overviewLabel.lineBreakMode = .byTruncatingTail

        let textStack = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        textStack.axis = .vertical
        textStack.spacing = 4

        let mainStack = UIStackView(arrangedSubviews: [posterImageView, textStack])
        mainStack.axis = .horizontal
        mainStack.alignment = .top
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImageView.heightAnchor.constraint(equalTo: mainStack.heightAnchor),
            posterImageView.widthAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 2.0 / 3.0),
        ])
    }
    
    func configureCell(movie: ListMovieEntity.Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        if let url = movie.posterPathURL {
            posterImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "film"),
                options: [.transition(.fade(0.2)), .cacheOriginalImage]
            )
        } else {
            posterImageView.image = UIImage(systemName: "film")
            print("For \(movie.title ?? "movie") unable to load posterPath")
        }

    }
}
