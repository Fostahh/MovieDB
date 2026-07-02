//
//  ReviewItem.swift
//  MovieDB
//

import MovieDBDataLayer

struct ReviewItem {
    let author: String
    let content: String
    let ratingText: String?
}

extension ReviewItem {
    init(_ entity: ReviewEntity) {
        self.init(
            author: entity.author ?? "Anonymous",
            content: entity.content ?? "",
            ratingText: entity.rating?.toRatingText
        )
    }
}
