//
//  RoomInformationViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import SendBirdCalls

class RoomInformationViewController: UIViewController, RoomDataSource {
    @IBOutlet weak var roomIdLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var room: Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomIdLabel.text = room.roomId
        nicknameLabel.text = "User ID: \(room.createdBy)"
    }
}
