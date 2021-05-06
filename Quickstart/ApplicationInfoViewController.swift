//
//  ApplicationInfoViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import SendBirdCalls

class ApplicationInfoViewController: UIViewController {
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appNameLabel.text = Bundle.main.appName ?? "—"
        appIdLabel.text = SendBirdCall.appId ?? "No configured app ID"
    }
}
