//
//  ParticipantGridTests.swift
//  QuickstartTests
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import XCTest
@testable import Quickstart

/// The tile sizes follow `RoomViewController.collectionView(_:layout:sizeForItemAt:)` of the UIKit sample.
final class ParticipantGridTests: XCTestCase {
    private let container = CGSize(width: 402, height: 666)

    func test_oneParticipant_fillsTheWidthIn3To4() {
        let grid = ParticipantGrid(count: 1, container: container)

        XCTAssertEqual(grid.tileSize.width, 394, accuracy: 0.01)
        XCTAssertEqual(grid.tileSize.height, 394 * 4 / 3, accuracy: 0.01)
        XCTAssertEqual(grid.columns, 1)
    }

    func test_twoToFourParticipants_useTwoColumns() {
        for count in 2...4 {
            let grid = ParticipantGrid(count: count, container: container)

            XCTAssertEqual(grid.tileSize.width, 197, accuracy: 0.01, "count \(count)")
            XCTAssertEqual(grid.tileSize.height, 197 * 4 / 3, accuracy: 0.01, "count \(count)")
            XCTAssertEqual(grid.columns, 2, "count \(count)")
        }
    }

    func test_fiveOrMoreParticipants_fitThreeRowsInTheHeight() {
        let grid = ParticipantGrid(count: 6, container: container)

        XCTAssertEqual(grid.tileSize.height, (666 - 8) / 3, accuracy: 0.01)
        XCTAssertEqual(grid.tileSize.width, (666 - 8) / 3 * 3 / 4, accuracy: 0.01)
        // 164.5 pt wide tiles with 4 pt spacing: two fit in 402 pt, three don't.
        XCTAssertEqual(grid.columns, 2)
    }

    func test_rows_splitParticipantsByColumns() {
        let grid = ParticipantGrid(count: 3, container: container)

        XCTAssertEqual(grid.rows(of: ["A", "B", "C"]), [["A", "B"], ["C"]])
    }
}
