//
//  UIView+QuickStart.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/30.
//

import UIKit
import SendBirdCalls

extension UIView {
    func embed(_ videoView: SendBirdVideoView) {
        insertSubview(videoView, at: 0)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[view]|",
                options: [],
                metrics: nil,
                views: ["view": videoView]
            )
        )
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[view]|",
                options: [],
                metrics: nil,
                views: ["view": videoView]
            )
        )
        
        layoutIfNeeded()
    }
    
    func animate(with duration: TimeInterval = 0.3, _ task: @escaping (()-> Void)) {
        DispatchQueue.main.async {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
                task()
                self.layoutIfNeeded()
            }
            animator.startAnimation()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }

     }

    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if newValue > 0 {
                clipsToBounds = true
            }
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            layer.borderColor.map(UIColor.init)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UITextField {
    @IBInspectable
    var isPaddingEnabled: Bool {
        get {
            guard let paddingView = leftView else { return false }
            return paddingView.frame.width != 0
        }
        set {
            guard newValue else { return }
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.height))
            leftView = paddingView
            leftViewMode = .always
            rightView = paddingView
            rightViewMode = .always
        }
    }
}
