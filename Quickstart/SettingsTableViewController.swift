//
//  SettingsTableViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import SendBirdCalls

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var userProfileImageView: UIImageView! {
        didSet {
            let profileURL = SendBirdCall.currentUser?.profileURL
            userProfileImageView.updateImage(urlString: profileURL)
        }
    }
    
    @IBOutlet weak var userIdLabel: UILabel! {
        didSet {
            userIdLabel.text = "User ID: \(SendBirdCall.currentUser?.userId ?? "")"
        }
    }
    
    @IBOutlet weak var nicknameLabel: UILabel! {
        didSet {
            nicknameLabel.text = SendBirdCall.currentUser?.nickname?.collapsed ?? "—"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 1:
            performSegue(withIdentifier: "appInfo", sender: nil)
        case 2:
            let alert = UIAlertController(title: "Do you want to sign out?",
                                          message: "If you sign out, you cannot receive any calls.",
                                          preferredStyle: .alert)
            
            let actionSignOut = UIAlertAction(title: "Sign Out", style: .default) { _ in
                SendBirdCall.deauthenticate { error in
                    self.dismiss(animated: true, completion: nil)
                }
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(actionSignOut)
            alert.addAction(actionCancel)
            
            present(alert, animated: true, completion: nil)
        default: return
        }
    }
}
