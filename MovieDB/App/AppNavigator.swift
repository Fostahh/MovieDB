//
//  AppNavigator.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit

protocol Navigator: AnyObject {
    // TODO: Stich Screens
}

class AppNavigator {
    private let screenFactory: ScreenFactory
    
    init(screenFactory: ScreenFactory) {
        self.screenFactory = screenFactory
    }
    
    func createInitialScreen() -> UINavigationController {
        UINavigationController(rootViewController: screenFactory.createListMovieScreen())
    }
}

extension AppNavigator: Navigator {
}
