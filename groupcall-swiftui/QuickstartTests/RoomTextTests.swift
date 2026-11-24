//
//  RoomTextTests.swift
//  QuickstartTests
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import XCTest
@testable import Quickstart

final class RoomTextTests: XCTestCase {
    func test_title_usesTitleCustomItem() {
        XCTAssertEqual(RoomText.title(customItems: ["title": " Standup "], roomId: "R1"), "Standup")
    }

    func test_title_missingOrBlank_usesRoomId() {
        XCTAssertEqual(RoomText.title(customItems: [:], roomId: "R1"), "R1")
        XCTAssertEqual(RoomText.title(customItems: ["title": "  "], roomId: "R1"), "R1")
    }

    func test_participantsTitle_showsCount() {
        XCTAssertEqual(RoomText.participantsTitle(count: 3), "Participants (3)")
    }
}
