//
//  SignInInputTests.swift
//  QuickstartTests
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import XCTest
@testable import Quickstart

final class SignInInputTests: XCTestCase {
    func test_validated_trimsValues() throws {
        let input = SignInInput(appId: "  APP_ID \n", userId: "\tuser1 ", accessToken: " token ")

        let credential = try input.validated()

        XCTAssertEqual(credential, SignInCredential(appId: "APP_ID", userId: "user1", accessToken: "token"))
    }

    func test_validated_blankAccessToken_signsInWithoutToken() throws {
        let input = SignInInput(appId: "APP_ID", userId: "user1", accessToken: "   ")

        let credential = try input.validated()

        XCTAssertNil(credential.accessToken)
    }

    func test_validated_blankAppId_throwsInvalidAppId() {
        let input = SignInInput(appId: "  ", userId: "user1", accessToken: "")

        XCTAssertThrowsError(try input.validated()) { error in
            XCTAssertEqual(error as? SignInInput.ValidationError, .invalidAppId)
            XCTAssertEqual(error.localizedDescription, "Please enter valid app ID")
        }
    }

    func test_validated_blankUserId_throwsInvalidUserId() {
        let input = SignInInput(appId: "APP_ID", userId: "", accessToken: "")

        XCTAssertThrowsError(try input.validated()) { error in
            XCTAssertEqual(error as? SignInInput.ValidationError, .invalidUserId)
            XCTAssertEqual(error.localizedDescription, "Please enter valid user ID")
        }
    }

    func test_validated_bothBlank_reportsAppIdFirst() {
        let input = SignInInput(appId: "", userId: "", accessToken: "")

        XCTAssertThrowsError(try input.validated()) { error in
            XCTAssertEqual(error as? SignInInput.ValidationError, .invalidAppId)
        }
    }
}
