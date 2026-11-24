//
//  ParticipantTile.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// One participant on the room screen: the video, or the profile image while the video is off,
/// and the user ID with a muted icon at the bottom.
struct ParticipantTile: View {
    let item: ParticipantItem
    /// `nil` while the participant can't show video yet.
    let participant: Participant?
    /// Mirrors the video, for the local participant's front camera.
    var isMirrored = false
    /// Covers the video, while the local participant's camera switches.
    var isCovered = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Theme.tileBackground
            // A remote participant's video can show only after its stream started, as in the UIKit sample.
            if let participant, item.isLocal || item.isStreaming {
                ParticipantVideoView(participant: participant)
                    .scaleEffect(x: isMirrored ? -1 : 1, y: 1)
                    // Only this cover fades. The mirroring above changes at once, while the cover hides it.
                    .overlay {
                        Theme.tileBackground
                            .opacity(isCovered ? 1 : 0)
                            .animation(.easeInOut(duration: 0.15), value: isCovered)
                    }
            }
            if !item.isVideoEnabled {
                Theme.tileBackground
                ProfileImage(url: item.profileURL)
                    .frame(width: 80, height: 80)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            label
        }
        .clipped()
    }

    private var label: some View {
        HStack(spacing: 4) {
            if !item.isAudioEnabled {
                Image("iconAudioOffRed")
                    .resizable()
                    .frame(width: 11, height: 11)
            }
            Text(UserText.userId(item.userId))
                .font(.system(size: 11))
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .padding(.leading, item.isAudioEnabled ? 8 : 9)
        .padding(.trailing, 8)
        .frame(height: 20)
        .background(.black.opacity(0.55))
    }
}
