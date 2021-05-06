//
//  UIViewController+QuickStart.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit

extension UIViewController: UITextFieldDelegate {
    static var topViewController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        } else {
            return nil
        }
    }
    
    func presentErrorAlert(title: String = "Error", message: String, doneTitle: String = "Done", closeHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionDone = UIAlertAction(title: doneTitle, style: .cancel, handler: closeHandler)
        alert.addAction(actionDone)
        present(alert, animated: true, completion: nil)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            textField.layer.borderWidth = 0.0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        textField.resignFirstResponder()
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut) {
            textField.layer.borderWidth = 1.0
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text?.collapsed != nil else {
            return false
        }

        textField.resignFirstResponder()
        return true
    }
}
