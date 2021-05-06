//
//  MainViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import NotificationCenter
import SendBirdCalls

class MainViewController: UIViewController {
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var roomIdTextField: UITextField!
    
    @IBOutlet weak var roomEnterButton: UIButton!
    
    @IBOutlet var enterButtonConstraint: NSLayoutConstraint?
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdLabel.text = "User ID: \(SendBirdCall.currentUser?.userId ?? "")"
        nicknameLabel.text = SendBirdCall.currentUser?.nickname?.collapsed ?? "—"
        userProfileImageView.updateImage(urlString: SendBirdCall.currentUser?.profileURL)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination.children.first as? RoomDataSource {
            destination.room = sender as? Room
        }
    }
    
    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) { }
    
    @IBAction func didTapJoinRoomButton(_ sender: Any) {
        guard let roomId = roomIdTextField.text?.collapsed else { return }
        joinRoom(roomId)
    }
    
    @IBAction func didTapCreateRoomButton(_ sender: Any) {
        SendBirdCall.createRoom(with: RoomParams(roomType: .smallRoomForVideo)) { (room, error) in
            guard error == nil, let room = room else {
                self.presentErrorAlert(message: error?.localizedDescription ?? "Failed to create a room.")
                return
            }
            
            room.enter(with: Room.EnterParams(isVideoEnabled: true, isAudioEnabled: true)) { (error) in
                guard error == nil else {
                    self.presentErrorAlert(message: error?.localizedDescription ?? "Failed to enter a room.")
                    return
                }
                
                self.performSegue(withIdentifier: "enterRoom", sender: room)
            }
        }
    }
    
    func joinRoom(_ roomId: String) {
        SendBirdCall.fetchRoom(by: roomId) { (room, error) in
            guard error == nil, let room = room else {
                self.presentErrorAlert(title: "Incorrect room ID", message: "Check your room ID and try again.", doneTitle: "OK")
                return
            }
            
            self.performSegue(withIdentifier: "joinRoom", sender: room)
        }
    }
}

extension MainViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            view.animate {
                self.bottomSpacingConstraint.constant = keyboardHeight - 44
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.animate {
            self.bottomSpacingConstraint.constant = 0
        }
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let roomId = roomIdTextField.text?.collapsed else { return false }
        
        joinRoom(roomId)
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        view.animate {
            let isTextEmpty = sender.text?.collapsed == nil
            self.roomEnterButton.isHidden = isTextEmpty
            self.enterButtonConstraint?.isActive = isTextEmpty
        }
    }
}
