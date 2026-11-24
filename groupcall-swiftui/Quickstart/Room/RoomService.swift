//
//  RoomService.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import Foundation
import SendBirdCalls

/// Creates, fetches and enters rooms with Sendbird Calls.
@MainActor
enum RoomService {
    /// Creates a video room for up to 6 participants. The title is kept in the room's custom items.
    static func createRoom(title: String) async throws -> Room {
        let params = RoomParams(roomType: .smallRoomForVideo, customItems: ["title": title])
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Room, Error>) in
            SendBirdCall.createRoom(with: params) { room, error in
                if let room {
                    continuation.resume(returning: room)
                } else {
                    continuation.resume(throwing: error ?? RoomError.createFailed)
                }
            }
        }
    }

    /// Fetches the latest state of a room from Sendbird server.
    static func fetchRoom(id: String) async throws -> Room {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Room, Error>) in
            SendBirdCall.fetchRoom(by: id) { room, error in
                if let room {
                    continuation.resume(returning: room)
                } else {
                    continuation.resume(throwing: error ?? RoomError.fetchFailed)
                }
            }
        }
    }

    /// Enters a room. Read `room.localParticipant` only after this returns: it is `nil` before entering.
    static func enter(_ room: Room, isAudioEnabled: Bool, isVideoEnabled: Bool) async throws {
        let params = Room.EnterParams(isVideoEnabled: isVideoEnabled, isAudioEnabled: isAudioEnabled)
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            room.enter(with: params) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}

enum RoomError: LocalizedError {
    case createFailed
    case fetchFailed
    case enterFailed

    var errorDescription: String? {
        switch self {
        case .createFailed: "Failed to create a room."
        case .fetchFailed: "Failed to fetch a room."
        case .enterFailed: "Failed to enter a room."
        }
    }
}
