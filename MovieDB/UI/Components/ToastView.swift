//
//  ToastView.swift
//  MovieDB
//
//  Created by Mohammad Azri Khairuddin on 27/06/26.
//

import UIKit

enum Toast {
    private static weak var current: ToastView?
    
    static func showMessage(_ message: String, type: ToastView.ToastType, duration: TimeInterval = 2.0) {
        guard let container = topViewController?.view else { return }
        let toast = current ?? ToastView()
        current = toast
        toast.show(in: container, message: message, type: type, duration: duration)
    }
    
    private static var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { $0.isKeyWindow }
        
        var top = keyWindow?.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

final class ToastView: UIView {
    enum ToastType {
        case informative
        case success
        case error
    }
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private var dismissWorkItem: DispatchWorkItem?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
        alpha = 0
        
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func show(in parent: UIView, message: String, type: ToastType, duration: TimeInterval = 2.0) {
        contentLabel.text = message
        
        switch type {
        case .informative:
            backgroundColor = .systemGray
        case .success:
            backgroundColor = .systemGreen
        case .error:
            backgroundColor = .systemRed
        }
        
        if superview != parent {
            removeFromSuperview()
            parent.addSubview(self)
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 8),
                leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 12),
                trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -12),
            ])
        }
        parent.bringSubviewToFront(self)
        
        dismissWorkItem?.cancel()
        UIView.animate(withDuration: 0.25) { self.alpha = 1 }
        
        let workItem = DispatchWorkItem { [weak self] in
            UIView.animate(withDuration: 0.25, animations: {
                self?.alpha = 0
            }, completion: { finished in
                if finished { self?.removeFromSuperview() }
            })
        }
        dismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
    }
}
