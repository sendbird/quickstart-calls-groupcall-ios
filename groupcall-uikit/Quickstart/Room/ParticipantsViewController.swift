//
//  ParticipantsViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import SendBirdCalls

class ParticipantsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RoomDataSource {

    @IBOutlet weak var participantsTableView: UITableView!
    
    var room: Room!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Participants (\(room.participants.count))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.participants.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == room.participants.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "editRoomName") ?? UITableViewCell()
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == room.participants.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shareRoomId") ?? UITableViewCell()
            cell.selectionStyle = .none
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "participant") as? ParticipantTableViewCell else { return UITableViewCell() }
        cell.userIdLabel.text = "User ID: \(room.participants[indexPath.row].user.userId)"
        cell.nicknameLabel.text = room.participants[indexPath.row].user.nickname?.collapsed ?? "—"
        cell.profileImageView.updateImage(urlString: room.participants[indexPath.row].user.profileURL)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == room.participants.count {
            let controller = UIAlertController(title: "Edit room name", message: nil, preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Room name"
            }
            controller.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                guard let roomName = controller.textFields?.first?.text else { return }
                self.room.updateCustomItems(customItems: ["title": roomName]) { customItems, updatedKeys, error in
                    print("Updated custom items: \(String(describing: customItems)), updated keys: \(String(describing: updatedKeys)), error: \(String(describing: error))")
                }
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            self.present(controller, animated: true)
            
        } else if indexPath.row == room.participants.count + 1 {
            let activityViewController = UIActivityViewController(activityItems: [room.roomId], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = view
            
            present(activityViewController, animated: true, completion: nil)
        }
    }
}

class ParticipantTableViewCell: UITableViewCell {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
}
