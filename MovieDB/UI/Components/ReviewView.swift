//
//  ReviewView.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit

final class ReviewView: UIView {
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        
        let header = UIStackView(arrangedSubviews: [authorLabel, ratingLabel])
        header.axis = .horizontal
        header.spacing = 8
        header.alignment = .firstBaseline
        
        let stack = UIStackView(arrangedSubviews: [header, contentLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
    func configure(with item: ReviewItem, contentLineLimit: Int = 0) {
        authorLabel.text = item.author
        contentLabel.text = item.content
        contentLabel.numberOfLines = contentLineLimit
        
        ratingLabel.text = item.ratingText
        ratingLabel.isHidden = item.ratingText == nil
    }
}
