//
//  ShimmerView.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 26/06/26.
//

import UIKit

final class ShimmerView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        addShimmerAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setup() {
        isUserInteractionEnabled = false
        gradientLayer.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray3.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 0.5, 1]
        layer.addSublayer(gradientLayer)
        addShimmerAnimation()
    }
    
    private func addShimmerAnimation() {
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [-1.0, -0.5, 0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.25
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }
}
