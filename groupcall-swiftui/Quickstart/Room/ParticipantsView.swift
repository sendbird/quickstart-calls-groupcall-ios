//
//  ParticipantsView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// Lists the participants, and changes the room's title or shares the room ID.
struct ParticipantsView: View {
    let session: RoomSession

    // `SwiftUI.State`, not `State`: see `MainView`.
    @SwiftUI.State private var isEditingTitle = false
    @SwiftUI.State private var newTitle = ""
    @SwiftUI.State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(session.participants) { item in
                    participantRow(item)
                    divider
                }
                Button {
                    newTitle = ""
                    isEditingTitle = true
                } label: {
                    menuRow(image: "iconSettings", title: "Edit room name")
                }
                .buttonStyle(.plain)
                divider
                ShareLink(item: session.room.roomId) {
                    menuRow(image: "iconCopy", title: "Share room ID")
                }
                .buttonStyle(.plain)
                divider
            }
        }
        .background(.white)
        .navigationTitle(RoomText.participantsTitle(count: session.participants.count))
        .navigationBarTitleDisplayMode(.inline)
        .alert("Edit room name", isPresented: $isEditingTitle) {
            TextField("Room name", text: $newTitle)
            Button("Edit") { rename() }
            Button("Cancel", role: .destructive) { }
        }
        .errorAlert($errorMessage)
    }

    private func participantRow(_ item: ParticipantItem) -> some View {
        HStack(spacing: 16) {
            ProfileImage(url: item.profileURL)
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(UserText.nickname(item.nickname))
                    .font(.system(size: 16))
                Text(UserText.userId(item.userId))
                    .font(.system(size: 12))
                    .foregroundStyle(.black.opacity(0.38))
            }
            Spacer()
        }
        .padding(.leading, 15)
        .frame(height: 56)
    }

    private func menuRow(image: String, title: String) -> some View {
        HStack(spacing: 16) {
            Image(image)
                .resizable()
                .frame(width: 24, height: 24)
            Text(title)
                .font(.system(size: 16))
                .foregroundStyle(Theme.primaryText)
            Spacer()
        }
        .padding(.leading, 24)
        .frame(height: 56)
        .contentShape(Rectangle())
    }

    /// Like the default separator of a table.
    private var divider: some View {
        Rectangle()
            .fill(Theme.divider)
            .frame(height: 1)
            .padding(.leading, 16)
    }

    private func rename() {
        let title = newTitle
        Task {
            do {
                try await session.rename(to: title)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
