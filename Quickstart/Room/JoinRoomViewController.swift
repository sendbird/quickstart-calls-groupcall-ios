//
//  JoinRoomViewController.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/25.
//

import UIKit
import AVKit
import SendBirdCalls

class JoinRoomViewController: UIViewController, RoomDataSource {
    
    @IBOutlet weak var audioMuteButton: UIButton!
    @IBOutlet weak var videoDisableButton: UIButton!
    
    @IBOutlet weak var cameraView: UIView!
    
    var room: Room!
    
    var session: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginSession()
    }
    
    func beginSession() {
        let session = AVCaptureSession()
        session.sessionPreset = .vga640x480
        
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
           let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) {
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        cameraView.layer.masksToBounds = true
        cameraView.layer.addSublayer(previewLayer)
        previewLayer.frame = cameraView.bounds
        
        session.startRunning()
        self.session = session
    }
    
    @IBAction func didTapAudioButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            audioMuteButton.setImage(UIImage(named: "iconCheckboxOn"), for: .normal)
        } else {
            audioMuteButton.setImage(UIImage(named: "iconCheckboxOff"), for: .normal)
        }
    }
    
    @IBAction func didTapVideoButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            session?.stopRunning()
            cameraView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            videoDisableButton.setImage(UIImage(named: "iconCheckboxOn"), for: .normal)
        } else {
            beginSession()
            videoDisableButton.setImage(UIImage(named: "iconCheckboxOff"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session?.stopRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        session?.startRunning()
    }
    
    @IBAction func didTapJoinButton(_ sender: Any) {
        session?.stopRunning()
        session = nil
        
        let enterParams = Room.EnterParams(isVideoEnabled: !videoDisableButton.isSelected,
                                           isAudioEnabled: !audioMuteButton.isSelected)
        room.enter(with: enterParams) { [self] (error) in
            guard error == nil else {
                beginSession()
                presentErrorAlert(message: error?.localizedDescription ?? "Failed to enter room")
                return
            }
            
            performSegue(withIdentifier: "join", sender: room)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination.children.first as? RoomDataSource {
            destination.room = sender as? Room
        }
    }
}
