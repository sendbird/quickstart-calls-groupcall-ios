//
//  ShareRoomIdViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/30.
//

import UIKit
import SendBirdCalls

class ShareRoomIdViewController: UIViewController, RoomDataSource {
    @IBOutlet var roomIdLabel: UILabel!
    
    var room: Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomIdLabel.text = room.roomId
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBAction func didTapShareRoomId(_ sender: Any) {
        let activityViewController = UIActivityViewController(
            activityItems: [room.roomId],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapOK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
