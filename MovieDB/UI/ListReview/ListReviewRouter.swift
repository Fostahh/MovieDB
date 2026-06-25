
//  ListReviewRouter.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import UIKit

final class ListReviewRouter: ListReviewPresenterToRouter {
    weak var presenter: ListReviewRouterToPresenter?
    weak var navigator: Navigator?
}
