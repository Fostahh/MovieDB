//
//  ScreenFactory.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit
import MovieDBDataLayer

class ScreenFactory {

    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func createHomeScreen() -> UIViewController {
        return UIViewController()
    }
    
}
