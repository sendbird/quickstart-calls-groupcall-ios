//
//  UserTextTests.swift
//  QuickstartTests
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import XCTest
@testable import Quickstart

final class UserTextTests: XCTestCase {
    func test_nickname_trimsNickname() {
        XCTAssertEqual(UserText.nickname(" Jed "), "Jed")
    }

    func test_nickname_missingOrBlank_showsDash() {
        XCTAssertEqual(UserText.nickname(nil), "—")
        XCTAssertEqual(UserText.nickname(" \n"), "—")
    }

    func test_userId() {
        XCTAssertEqual(UserText.userId("user1"), "User ID: user1")
        XCTAssertEqual(UserText.userId(nil), "User ID: ")
    }
}
