//
//  Error+Ext.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 02/07/26.
//

import Foundation
import MovieDBDataLayer

extension Error {
    var displayMessage: String {
        (self as? NetworkError)?.errorMessage ?? localizedDescription
    }
}
