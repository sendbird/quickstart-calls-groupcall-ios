//
//  RoomText.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import Foundation

/// Texts about a room.
enum RoomText {
    /// The room title kept in the room's custom items, or the room ID when there is no title.
    static func title(customItems: [String: String], roomId: String) -> String {
        customItems["title"]?.collapsed ?? roomId
    }

    static func participantsTitle(count: Int) -> String {
        "Participants (\(count))"
    }
}
