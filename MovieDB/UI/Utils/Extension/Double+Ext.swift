//
//  Double+Ext.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 25/06/26.
//

import Foundation

extension Double {
    var toRatingText: String? {
        guard self >= 0 else { return nil }
        return String(format: "★ %.1f", self)
    }
}
