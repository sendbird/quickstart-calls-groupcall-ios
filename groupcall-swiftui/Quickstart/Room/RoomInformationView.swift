//
//  RoomInformationView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import SwiftUI

/// Shows the room ID, the room title and who created the room.
struct RoomInformationView: View {
    let room: Room

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            item(title: "Room ID", value: room.roomId)
            item(title: "Room name", value: room.customItems["title"] ?? "")
            item(title: "Created by", value: UserText.userId(room.createdBy))
            Spacer()
        }
        .background(.white)
        .navigationTitle("Room information")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func item(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.secondaryText)
                Text(value)
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.primaryText)
                    .textSelection(.enabled)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 16)
            Rectangle()
                .fill(Theme.divider)
                .frame(height: 1)
                .padding(.horizontal, 16)
        }
    }
}
