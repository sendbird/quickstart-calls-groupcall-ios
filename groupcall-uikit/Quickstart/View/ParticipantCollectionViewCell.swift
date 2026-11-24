//
//  ParticipantCollectionViewCell.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import UIKit
import SendBirdCalls

class ParticipantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var audioMutedImageView: UIImageView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet var profileImageBackgroundView: UIView!
    @IBOutlet var userIdLabelLeadingConstraint: NSLayoutConstraint?
    
    var participant: Participant? {
        didSet {
            guard let participant = participant else { return }
            updateView(with: participant)
            
            guard oldValue?.participantId != participant.participantId else { return }
            if participant is LocalParticipant || participant.state == .connected {
                registerVideoView(with: participant)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.participant = nil
    }
    
    func updateView(with participant: Participant) {
        userIdLabel.text = "User ID: \(participant.user.userId)"
        audioMutedImageView.isHidden = participant.isAudioEnabled
        profileImageView.isHidden = participant.isVideoEnabled
        profileImageBackgroundView.isHidden = participant.isVideoEnabled
        profileImageView.updateImage(urlString: participant.user.profileURL)
        userIdLabelLeadingConstraint?.isActive = participant.isAudioEnabled
    }
    
    func registerVideoView(with participant: Participant) {
        DispatchQueue.main.async { [self] in
            if let sendbirdVideoView = participant.videoView {
                sendbirdVideoView.removeFromSuperview()
                self.videoView.embed(sendbirdVideoView)
                return
            }
            
            let sendbirdVideoView = SendBirdVideoView(frame: videoView.frame, contentMode: .scaleAspectFit)
            sendbirdVideoView.backgroundColor = UIColor(white: 44.0 / 255.0, alpha: 1.0)
        
            participant.videoView = sendbirdVideoView
            videoView.embed(sendbirdVideoView)
        }
    }
}

extension ParticipantCollectionViewCell: RoomDelegate {
    func didRemoteParticipantExit(_ participant: RemoteParticipant) {
        guard participant.participantId == self.participant?.participantId else { return }
        
        videoView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func didRemoteParticipantStreamStart(_ participant: RemoteParticipant) {
        guard participant.participantId == self.participant?.participantId else { return }
        
        registerVideoView(with: participant)
    }
    
    func didRemoteAudioSettingsChange(_ participant: RemoteParticipant) {
        guard participant.participantId == self.participant?.participantId else { return }
        
        updateView(with: participant)
    }
    
    func didRemoteVideoSettingsChange(_ participant: RemoteParticipant) {
        guard participant.participantId == self.participant?.participantId else { return }
        
        updateView(with: participant)
    }
}
