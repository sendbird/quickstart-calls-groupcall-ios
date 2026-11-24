//
//  RoomSessionTests.swift
//  QuickstartTests
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import XCTest
@testable import Quickstart

final class RoomSessionTests: XCTestCase {
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
