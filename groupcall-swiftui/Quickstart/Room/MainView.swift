//
//  MainView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// Creates a room, or enters an existing room by its ID.
struct MainView: View {
    // `SwiftUI.State`, not `State`: SendBirdCalls also has types named `State` (`Room.State`, `Participant.State`),
    // and some Xcode versions, such as Xcode 26, report `State` as ambiguous in files that import both modules.
    @SwiftUI.State private var roomId = ""
    @SwiftUI.State private var roomTitle = ""
    @SwiftUI.State private var isAskingTitle = false
    @SwiftUI.State private var isWorking = false
    @SwiftUI.State private var isRoomIdIncorrect = false
    @SwiftUI.State private var errorMessage: String?
    @SwiftUI.State private var previewRoom: RoomItem?
    @SwiftUI.State private var enteredRoom: RoomItem?
    /// The room entered from the preview. It shows after the preview closes, because only one screen can show at a time.
    @SwiftUI.State private var roomEnteredFromPreview: Room?

    private var user: User? { AuthService.shared.currentUser }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    createCard
                    enterCard
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
            }
        }
        .background(Theme.mainBackground)
        .disabled(isWorking)
        .overlay {
            if isWorking { ProgressView() }
        }
        .alert("Create Room", isPresented: $isAskingTitle) {
            TextField("Enter room title", text: $roomTitle)
            Button("Create") { createRoom() }
            Button("Cancel", role: .destructive) { }
        }
        .alert("Incorrect room ID", isPresented: $isRoomIdIncorrect) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Check your room ID and try again.")
        }
        .errorAlert($errorMessage)
        .sheet(item: $previewRoom, onDismiss: showRoomEnteredFromPreview) { item in
            PreviewView(room: item.room) { room in
                roomEnteredFromPreview = room
                previewRoom = nil
            }
        }
        .fullScreenCover(item: $enteredRoom) { item in
            RoomView(room: item.room) {
                enteredRoom = nil
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 8) {
            ProfileImage(url: user?.profileURL)
                .frame(width: 34, height: 34)
            VStack(alignment: .leading, spacing: 2) {
                Text(UserText.nickname(user?.nickname))
                    .font(.system(size: 16, weight: .bold))
                Text(UserText.userId(user?.userId))
                    .font(.system(size: 12))
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .background(.white)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.divider).frame(height: 1)
        }
    }

    // MARK: - Cards

    private var createCard: some View {
        card(image: "iconRoomAdd",
             title: "Create a call",
             description: "Start a group call in a room and share the room ID with others.") {
            Button("Create") {
                roomTitle = ""
                isAskingTitle = true
            }
            .buttonStyle(FilledButtonStyle(height: 48))
        }
    }

    private var enterCard: some View {
        card(image: "iconJoin",
             title: "Enter with room ID",
             description: "Enter an existing room to participate in a group call.") {
            InputField(placeholder: "Room ID", text: $roomId, trailingInset: 52)
                .submitLabel(.join)
                .onSubmit { fetchRoom() }
                .overlay(alignment: .trailing) {
                    if roomId.collapsed != nil {
                        Button("Enter") { fetchRoom() }
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Theme.buttonPurple)
                            .frame(width: 40, height: 32)
                            .padding(.trailing, 12)
                    }
                }
                .animation(.default, value: roomId.collapsed == nil)
        }
    }

    private func card(image: String, title: String, description: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Theme.primaryText)
                .padding(.top, 16)
            Text(description)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Theme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
            content()
                .padding(.top, 24)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.12), radius: 8)
    }

    // MARK: - Actions

    /// Creates a room with the title and enters it with the microphone and the camera on, without the preview.
    private func createRoom() {
        let title = roomTitle
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                let room = try await RoomService.createRoom(title: title)
                try await RoomService.enter(room, isAudioEnabled: true, isVideoEnabled: true)
                enteredRoom = RoomItem(room: room)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func showRoomEnteredFromPreview() {
        guard let room = roomEnteredFromPreview else { return }
        roomEnteredFromPreview = nil
        enteredRoom = RoomItem(room: room)
    }

    /// Fetches the room with the ID, then shows the preview before entering.
    private func fetchRoom() {
        guard let id = roomId.collapsed else { return }
        isWorking = true
        Task {
            defer { isWorking = false }
            do {
                let room = try await RoomService.fetchRoom(id: id)
                previewRoom = RoomItem(room: room)
            } catch {
                isRoomIdIncorrect = true
            }
        }
    }
}

/// A room shown over the main screen.
struct RoomItem: Identifiable {
    let room: Room

    var id: String { room.roomId }
}
