//
//  RoomViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import SendBirdCalls
import AVKit

protocol RoomDataSource: AnyObject {
    var room: Room! { get set }
}

class RoomViewController: UIViewController, RoomDataSource {
    @IBOutlet weak var roomIdLabel: UILabel!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet var audioRouteButton: UIButton!
    @IBOutlet weak var participantsCollectionView: UICollectionView!
    
    var room: Room!
    var localParticipantIndex: [IndexPath] {
        if let index = self.room.participants.firstIndex(where: { $0 is LocalParticipant }) {
            return [IndexPath(row: index, section: 0)]
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomIdLabel.text = room.customItems["title"]?.collapsed ?? room.roomId
        room.addDelegate(self, identifier: "RoomViewController")
        
        participantsCollectionView.register(UINib(nibName: "ParticipantCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "participant")
        participantsCollectionView.reloadData()
        
        setupAudioOutputButton()
        configureMediaButtons()
        
        if room.createdBy == room.localParticipant?.user.userId {
            performSegue(withIdentifier: "shareRoomId", sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? RoomDataSource {
            destination.room = room
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        roomIdLabel.text = room.customItems["title"]?.collapsed ?? room.roomId
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func didTapExitButton(_ sender: UIButton) {
        try? room.exit()
        self.performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    @IBAction func didTapMicrophoneButton(_ sender: Any) {
        if room.localParticipant?.isAudioEnabled == true {
            room.localParticipant?.muteMicrophone()
        } else {
            room.localParticipant?.unmuteMicrophone()
        }
        configureMediaButtons()
        UIView.performWithoutAnimation {
            participantsCollectionView.reloadItems(at: localParticipantIndex)
        }
    }
    
    @IBAction func didTapCameraButton(_ sender: UIButton) {
        if room.localParticipant?.isVideoEnabled == true {
            room.localParticipant?.stopVideo()
        } else {
            room.localParticipant?.startVideo()
        }
        configureMediaButtons()
        UIView.performWithoutAnimation {
            participantsCollectionView.reloadItems(at: localParticipantIndex)
        }
    }
    
    @IBAction func didTapFlipCameraButton(_ sender: Any) {
        room.localParticipant?.switchCamera { error in
            if let error = error { print("Failed to flip camera with error: \(error)") }
        }
    }
    
    func configureMediaButtons() {
        let microphoneButtonImage = UIImage(
            named: room.localParticipant?.isAudioEnabled == true
                ? "btnAudioOff"
                : "btnAudioOffSelected")
        
        microphoneButton.setImage(microphoneButtonImage, for: .normal)
        
        let cameraButtonImage = UIImage(
            named: room.localParticipant?.isVideoEnabled == true
                ? "btnVideoOff"
                : "btnVideoOffSelected")
        cameraButton.setImage(cameraButtonImage, for: .normal)
    }
    
    func setupAudioOutputButton() {
        let width = audioRouteButton.frame.width
        let height = audioRouteButton.frame.height
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        if let routePickerView = SendBirdCall.routePickerView(frame: frame) as? AVRoutePickerView {
            routePickerView.activeTintColor = .clear
            routePickerView.tintColor = .clear
            audioRouteButton.addSubview(routePickerView)
        }
    }
}

extension RoomViewController: RoomDelegate {
    func didRemoteParticipantEnter(_ participant: RemoteParticipant) {
        participantsCollectionView.reloadData()
    }
    
    func didRemoteParticipantExit(_ participant: RemoteParticipant) {
        participantsCollectionView.reloadData()
    }
    
    func didReceiveError(_ error: SBCError, participant: Participant?) {
        print("Received error: \(error) with participant: \(String(describing: participant))")
        try? room.exit()
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    func didDeleteCustomItems(deletedKeys: [String]) {
        print("Did delete custom items for keys: \(deletedKeys)")
    }
    
    func didUpdateCustomItems(updatedKeys: [String]) {
        print("Did update custom items for keys: \(updatedKeys)")
        if updatedKeys.contains(where: { $0 == "title" }) {
            self.roomIdLabel.text = room.customItems["title"]?.collapsed ?? room.roomId
        }
    }
}

extension RoomViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return room.participants.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "participant", for: indexPath) as? ParticipantCollectionViewCell else { return UICollectionViewCell() }
        
        collectionView.contentInset.top = max((collectionView.frame.height - collectionView.contentSize.height) / 2, 0)
        
        let participant = room.participants[indexPath.row]
        cell.participant = participant
        
        room.addDelegate(cell, identifier: participant.participantId)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch room.participants.count {
        case ...1:
            let width = UIScreen.main.bounds.width - 8
            let height = 4/3 * width
            return CGSize(width: width, height: height)
        case 2...4:
            let width = (UIScreen.main.bounds.width - 8)/2
            let height = 4/3 * width
            return CGSize(width: width, height: height)
        default:
            let height = (collectionView.bounds.height - 8) / 3
            let width = 3/4 * height
            return CGSize(width: width, height: height)
        }
    }
}
