//
//  ReviewTableViewCell.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit

final class ReviewTableViewCell: UITableViewCell {
    static let identifier = "ReviewTableViewCell"
    
    private let reviewView = ReviewView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reviewView)
        
        NSLayoutConstraint.activate([
            reviewView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            reviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func configureCell(review: ReviewItem) {
        reviewView.configure(with: review)
    }
}
