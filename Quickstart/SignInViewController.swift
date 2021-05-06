//
//  SignInViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//
import UIKit
import SendBirdCalls

class SignInViewController: UIViewController {
    @IBOutlet weak var appIdTextField: UITextField!
    @IBOutlet weak var userIdTextField: UITextField!
    @IBOutlet weak var accessTokenTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var versionLabel: UILabel! {
        didSet {
            versionLabel.text = "QuickStart \(Bundle.main.appVersion ?? "")\tSDK \(SendBirdCall.sdkVersion)"
        }
    }
    
    @IBAction func didTapSignInButton(_ sender: Any) {
        guard let appId = appIdTextField.text?.collapsed else {
            presentErrorAlert(message: "Please enter valid app ID")
            return
        }
        
        guard let userId = userIdTextField.text?.collapsed else {
            presentErrorAlert(message: "Please enter valid user ID")
            return
        }
        
        let accessToken = accessTokenTextField.text
        
        SendBirdCall.configure(appId: appId)
        SendBirdCall.authenticate(with: AuthenticateParams(userId: userId, accessToken: accessToken)) { [self] (user, error) in
            guard error == nil else {
                presentErrorAlert(message: error?.localizedDescription ?? "Failed to authenticate")
                return
            }
            
            performSegue(withIdentifier: "signIn", sender: self)
        }
    }
}
