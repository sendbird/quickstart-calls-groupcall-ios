//
//  ParticipantVideoView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// Shows the video of a participant.
///
/// The `SendBirdVideoView` is created and given to the participant only once, in `makeUIView(context:)`.
/// SwiftUI calls `updateUIView(_:context:)` whenever the screen redraws, so creating a new view there
/// would make the video flicker or stop. `Participant.videoView` is a weak reference, so this view keeps it alive.
struct ParticipantVideoView: UIViewRepresentable {
    let participant: Participant

    func makeUIView(context: Context) -> SendBirdVideoView {
        if let videoView = participant.videoView {
            videoView.removeFromSuperview()
            return videoView
        }
        let videoView = SendBirdVideoView(frame: .zero, contentMode: .scaleAspectFit)
        videoView.backgroundColor = UIColor(white: 44 / 255, alpha: 1)
        participant.videoView = videoView
        return videoView
    }

    func updateUIView(_ videoView: SendBirdVideoView, context: Context) { }
}
