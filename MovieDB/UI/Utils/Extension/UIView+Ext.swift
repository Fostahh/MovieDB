//
//  UIView+Ext.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 24/06/26.
//

import UIKit

extension UIView {
    public var isShimmering: Bool {
        get { subviews.contains { $0 is ShimmerView } }
        set { newValue ? addShimmer() : removeShimmer() }
    }
    
    private func addShimmer() {
        guard !isShimmering else { return }
        let shimmer = ShimmerView()
        shimmer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(shimmer)
        NSLayoutConstraint.activate([
            shimmer.topAnchor.constraint(equalTo: topAnchor),
            shimmer.bottomAnchor.constraint(equalTo: bottomAnchor),
            shimmer.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func removeShimmer() {
        subviews.first { $0 is ShimmerView }?.removeFromSuperview()
    }
}
