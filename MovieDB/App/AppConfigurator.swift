//
//  AppConfigurator.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation
import UIKit
import MovieDBDataLayer

final class AppConfigurator {

    private let window: UIWindow
    private let appNavigator: AppNavigator

    init(window: UIWindow) {
        self.window = window

        let repository = AppConfigurator.injectingDataLayer()
        let screenFactory = ScreenFactory(repository: repository, imageBaseURL: AppConfigurator.imageBaseURL)
        self.appNavigator = AppNavigator(screenFactory: screenFactory)
    }

    func start() {
        window.rootViewController = appNavigator.createInitialScreen()
    }
}

// MARK: - Injecting Data Layer
private extension AppConfigurator {
    static func injectingDataLayer() -> MovieRepository {
        DataLayerFactory.makeRepository(
            authToken: authToken,
            baseURL: baseURL
        )
    }
}

// MARK: - Variables For Data Layer
private extension AppConfigurator {
    static var authToken: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "AuthToken") as? String,
              !value.isEmpty,
              value != "$(AUTH_TOKEN)" else {
            fatalError("AUTH_TOKEN is missing")
        }
        return value
    }
    
    static var baseURL: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String,
              !value.isEmpty,
              value != "$(BASE_URL)" else {
            fatalError("BASE_URL is missing")
        }
        return value
    }

    static var imageBaseURL: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String,
              !value.isEmpty,
              value != "$(IMAGE_BASE_URL)" else {
            fatalError("IMAGE_BASE_URL is missing")
        }
        return value
    }
}
