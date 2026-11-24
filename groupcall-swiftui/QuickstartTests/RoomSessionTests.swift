//
//  RoomSessionTests.swift
//  QuickstartTests
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SendBirdCalls
import XCTest
@testable import Quickstart

final class RoomSessionTests: XCTestCase {
    // The custom item methods of `RoomDelegate` are optional Objective-C requirements, so Sendbird Calls calls them
    // only when the delegate responds to their selectors. A method with another name compiles without a warning
    // but is never called, and the room title doesn't change when another participant renames the room.

    func test_roomDelegate_receivesCustomItemsUpdate() {
        XCTAssertTrue(RoomSession.instancesRespond(to: #selector(RoomDelegate.didCustomItemsUpdate(updatedKeys:))))
    }

    func test_roomDelegate_receivesCustomItemsDelete() {
        XCTAssertTrue(RoomSession.instancesRespond(to: #selector(RoomDelegate.didCustomItemsDelete(deletedKeys:))))
    }

    func test_participantOrder_localFirstThenEnterOrder() {
        let ordered = RoomSession.ordered(["A", "L", "B"], isLocal: { $0 == "L" })

        XCTAssertEqual(ordered, ["L", "A", "B"])
    }

    func test_participantOrder_afterRemoteExits_keepsOthersInOrder() {
        let ordered = RoomSession.ordered(["L", "B"], isLocal: { $0 == "L" })

        XCTAssertEqual(ordered, ["L", "B"])
    }

    func test_participantOrder_withoutLocal_keepsOrder() {
        let ordered = RoomSession.ordered(["A", "B"], isLocal: { $0 == "L" })

        XCTAssertEqual(ordered, ["A", "B"])
    }
}
