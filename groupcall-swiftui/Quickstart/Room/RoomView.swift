//
//  RoomView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// The screen of a room after entering: the participants' videos and the controls.
struct RoomView: View {
    /// Called after the user left the room.
    let onExit: () -> Void

    // `SwiftUI.State`, not `State`: see `MainView`.
    @SwiftUI.State private var session: RoomSession
    @SwiftUI.State private var isShowingShareRoomId: Bool
    @SwiftUI.State private var isShowingInformation = false
    @SwiftUI.State private var isShowingParticipants = false

    /// `room` must be entered already.
    init(room: Room, onExit: @escaping () -> Void) {
        self.onExit = onExit
        _session = SwiftUI.State(initialValue: RoomSession(room: room))
        // Right after creating a room, ask the user to share its ID, as the UIKit sample does.
        _isShowingShareRoomId = SwiftUI.State(initialValue: room.createdBy == room.localParticipant?.user.userId)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topBar
                GeometryReader { geometry in
                    grid(in: geometry.size)
                }
                bottomBar
            }
            .background(Theme.roomBackground)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $isShowingInformation) {
                RoomInformationView(room: session.room)
            }
            .navigationDestination(isPresented: $isShowingParticipants) {
                ParticipantsView(session: session)
            }
            .errorAlert($session.errorMessage)
        }
        .tint(Theme.purple)
        .overlay {
            if isShowingShareRoomId {
                ShareRoomIdView(roomId: session.room.roomId) {
                    isShowingShareRoomId = false
                }
            }
        }
        .task { session.start() }
        .onChange(of: session.hasExited) { _, hasExited in
            if hasExited { onExit() }
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack(spacing: 0) {
            Button {
                isShowingInformation = true
            } label: {
                HStack(spacing: 8) {
                    Image("iconRooms")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .frame(width: 34, height: 34)
                        .background(Theme.roomIconBackground, in: Circle())
                    Text(session.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white.opacity(0.88))
                        .lineLimit(1)
                        .frame(maxWidth: 150, alignment: .leading)
                    Image("iconShevronRight")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .buttonStyle(.plain)
            Spacer()
            Image("iconSpeaker")
                .resizable()
                .frame(width: 24, height: 24)
                .overlay { AudioRoutePicker() }
            Button {
                session.switchCamera()
            } label: {
                Image("iconCameraFlipIos")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .disabled(session.isSwitchingCamera || !session.isVideoEnabled)
            .padding(.leading, 24)
        }
        .padding(.leading, 20)
        .padding(.trailing, 14)
        .frame(height: 44)
    }

    // MARK: - Participants

    private func grid(in size: CGSize) -> some View {
        let layout = ParticipantGrid(count: session.participants.count, container: size)
        return VStack(spacing: ParticipantGrid.spacing) {
            ForEach(Array(layout.rows(of: session.participants).enumerated()), id: \.offset) { _, row in
                HStack(spacing: ParticipantGrid.spacing) {
                    ForEach(row) { item in
                        ParticipantTile(
                            item: item,
                            participant: session.participant(for: item),
                            isMirrored: item.isLocal && session.isUsingFrontCamera,
                            isCovered: item.isLocal && session.isSwitchingCamera
                        )
                        .frame(width: layout.tileSize.width, height: layout.tileSize.height)
                    }
                }
            }
        }
        .frame(width: size.width, height: size.height)
        .background(.black)
    }

    // MARK: - Bottom bar

    private var bottomBar: some View {
        ZStack {
            HStack(spacing: 12) {
                Button { session.toggleMic() } label: {
                    controlImage(session.isMicEnabled ? "btnAudioOff" : "btnAudioOffSelected")
                }
                Button { session.toggleVideo() } label: {
                    controlImage(session.isVideoEnabled ? "btnVideoOff" : "btnVideoOffSelected")
                }
                Button { session.exit() } label: {
                    controlImage("btnCallEnd")
                }
            }
            HStack {
                Spacer()
                Button {
                    isShowingParticipants = true
                } label: {
                    VStack(spacing: 4) {
                        Image("icUser")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Participants")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.88))
                    }
                    .frame(width: 72, height: 64)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 12)
            }
        }
        .frame(height: 64)
    }

    private func controlImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .frame(width: 48, height: 48)
    }
}
