//
//  RoomSession.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import Foundation
import Observation
import SendBirdCalls

/// What the room screen shows about a participant.
struct ParticipantItem: Identifiable, Equatable {
    let id: String
    let userId: String
    let nickname: String?
    let profileURL: String?
    let isLocal: Bool
    let isAudioEnabled: Bool
    let isVideoEnabled: Bool
    /// `true` when the participant's media stream started. A remote participant's video can show only after that.
    let isStreaming: Bool
}

/// Publishes the state of one `Room` to the room screens and performs the user's actions on it.
///
/// Sendbird Calls doesn't notify views about its objects, so this reads the room again
/// whenever a `RoomDelegate` method or the user's action changes something.
@MainActor
@Observable
final class RoomSession: NSObject {
    let room: Room

    private(set) var participants: [ParticipantItem] = []
    private(set) var title = ""
    private(set) var isMicEnabled = false
    private(set) var isVideoEnabled = false
    private(set) var isUsingFrontCamera = true
    /// `true` while the camera switches. The room screen covers the local video meanwhile. See `switchCamera()`.
    private(set) var isSwitchingCamera = false
    /// `true` after the user left the room, or after an error made the app leave it.
    private(set) var hasExited = false
    var errorMessage: String?

    private var delegateIdentifier: String { "RoomSession.\(room.roomId)" }

    /// `room` must be entered already: `room.localParticipant` is `nil` before entering.
    init(room: Room) {
        self.room = room
        super.init()
        refresh()
    }

    /// Starts receiving the room's events. Call it when the room screen appears.
    func start() {
        room.addDelegate(self, identifier: delegateIdentifier)
        refresh()
    }

    /// Local participant first, then the others in the order they entered.
    nonisolated static func ordered<T>(_ participants: [T], isLocal: (T) -> Bool) -> [T] {
        participants.filter(isLocal) + participants.filter { !isLocal($0) }
    }

    /// The Sendbird Calls participant for an item, to show its video.
    func participant(for item: ParticipantItem) -> Participant? {
        room.participants.first { $0.participantId == item.id }
    }

    /// Reads the participants, the title and the local media state from the room again.
    private func refresh() {
        let sorted = Self.ordered(room.participants, isLocal: { $0 is LocalParticipant })
        participants = sorted.map { participant in
            ParticipantItem(
                id: participant.participantId,
                userId: participant.user.userId,
                nickname: participant.user.nickname,
                profileURL: participant.user.profileURL,
                isLocal: participant is LocalParticipant,
                isAudioEnabled: participant.isAudioEnabled,
                isVideoEnabled: participant.isVideoEnabled,
                isStreaming: participant.state == .connected
            )
        }
        title = RoomText.title(customItems: room.customItems, roomId: room.roomId)
        isMicEnabled = room.localParticipant?.isAudioEnabled ?? false
        isVideoEnabled = room.localParticipant?.isVideoEnabled ?? false
    }

    // MARK: - User actions

    func toggleMic() {
        guard let local = room.localParticipant else { return }
        if local.isAudioEnabled {
            local.muteMicrophone()
        } else {
            local.unmuteMicrophone()
        }
        // The participant changes its state at once, so read it again now.
        refresh()
    }

    func toggleVideo() {
        guard let local = room.localParticipant else { return }
        if local.isVideoEnabled {
            local.stopVideo()
        } else {
            local.startVideo()
        }
        refresh()
    }

    func switchCamera() {
        guard !isSwitchingCamera, let local = room.localParticipant else { return }
        // Cover the local video before switching. See below for why.
        isSwitchingCamera = true
        local.switchCamera { [weak self] error in
            guard let self else { return }
            Task { @MainActor in
                if let error {
                    self.isSwitchingCamera = false
                    self.errorMessage = error.localizedDescription
                    return
                }
                // Sendbird Calls calls this handler as soon as it asks the new camera to start, before the camera's
                // first frame arrives. Mirroring now would flip the old camera's last frames for a moment.
                // So keep the video covered a little longer, then mirror it for the new camera and show it again.
                try? await Task.sleep(for: .milliseconds(400))
                self.isUsingFrontCamera.toggle()
                self.isSwitchingCamera = false
            }
        }
    }

    func rename(to title: String) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            room.updateCustomItems(customItems: ["title": title]) { _, _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
        refresh()
    }

    func exit() {
        room.removeDelegate(identifier: delegateIdentifier)
        try? room.exit()
        hasExited = true
    }
}

// MARK: - RoomDelegate

// Sendbird Calls calls the delegate on the main queue by default, so the main-actor methods below are safe.
extension RoomSession: @preconcurrency RoomDelegate {
    func didRemoteParticipantEnter(_ participant: RemoteParticipant) {
        refresh()
    }

    func didRemoteParticipantExit(_ participant: RemoteParticipant) {
        refresh()
    }

    func didRemoteParticipantStreamStart(_ participant: RemoteParticipant) {
        refresh()
    }

    func didRemoteAudioSettingsChange(_ participant: RemoteParticipant) {
        refresh()
    }

    func didRemoteVideoSettingsChange(_ participant: RemoteParticipant) {
        refresh()
    }

    func didUpdateCustomItems(updatedKeys: [String]) {
        refresh()
    }

    func didDeleteCustomItems(deletedKeys: [String]) {
        refresh()
    }

    func didReceiveError(_ error: SBCError, participant: Participant?) {
        // As the UIKit sample does, leave the room when an error occurs, for example when the connection is lost.
        exit()
    }
}
