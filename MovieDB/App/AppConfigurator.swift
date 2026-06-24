//
//  AppConfigurator.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import Foundation
import UIKit

final class AppConfigurator {

    private let window: UIWindow
    private let appNavigator: AppNavigator

    init(window: UIWindow) {
        self.window = window

        let repository = AppConfigurator.injectingDataLayer()
        let screenFactory = ScreenFactory(repository: repository)
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
            apiKey: apiKey,
            authToken: authToken,
            baseURL: baseURL
        )
    }
}

// MARK: - Variables For Data Layer
private extension AppConfigurator {
    static var apiKey: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String,
              !value.isEmpty,
              value != "$(API_KEY)" else {
            fatalError("API_KEY is missing")
        }
        return value
    }

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
}
