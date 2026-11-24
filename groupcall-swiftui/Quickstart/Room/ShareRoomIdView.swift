//
//  ShareRoomIdView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SwiftUI

/// Shown over the room screen right after creating a room, so that the user can share the room ID.
struct ShareRoomIdView: View {
    let roomId: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.32)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("Room created!")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.top, 20)
                Text("Share the room ID to others to enter this room for group calls.")
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                ShareLink(item: roomId) {
                    HStack(spacing: 4) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Room ID")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.secondaryText)
                            Text(roomId)
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                                .lineLimit(1)
                        }
                        Spacer(minLength: 0)
                        Image("iconCopy")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .padding(16)
                    .background(Theme.mainBackground, in: RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
                .padding(.horizontal, 16)
                Rectangle()
                    .fill(Theme.divider)
                    .frame(height: 0.5)
                    .padding(.top, 16)
                Button(action: onClose) {
                    Text("OK")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.buttonPurple)
                        .frame(maxWidth: .infinity, minHeight: 47.5)
                }
            }
            .frame(width: 270)
            .background(.white, in: RoundedRectangle(cornerRadius: 14))
        }
    }
}
