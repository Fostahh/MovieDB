//
//  ReviewItem+Mapping.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation
import MovieDBDataLayer

extension ReviewItem {
    init(_ entity: ReviewEntity) {
        self.init(
            author: entity.author ?? "Anonymous",
            content: entity.content ?? "",
            ratingText: entity.rating?.toRatingText
        )
    }
}
