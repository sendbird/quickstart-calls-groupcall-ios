//
//  ParticipantGrid.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import CoreGraphics

/// The size of the participant tiles and how many fit in a row, as in the UIKit sample.
///
/// - One participant: one tile as wide as the screen.
/// - Two to four: two tiles in a row.
/// - Five or six: three rows that fill the height.
///
/// Tiles are 3:4, with 4 pt between them.
struct ParticipantGrid {
    static let spacing: CGFloat = 4

    let tileSize: CGSize
    let columns: Int

    init(count: Int, container: CGSize) {
        let spacing = Self.spacing
        switch count {
        case ...1:
            let width = container.width - 2 * spacing
            tileSize = CGSize(width: width, height: width * 4 / 3)
        case 2...4:
            let width = (container.width - 2 * spacing) / 2
            tileSize = CGSize(width: width, height: width * 4 / 3)
        default:
            let height = (container.height - 2 * spacing) / 3
            tileSize = CGSize(width: height * 3 / 4, height: height)
        }
        // As many tiles as fit in a row, like a flow layout.
        columns = max(1, Int((container.width + spacing) / (tileSize.width + spacing)))
    }

    /// Splits the items into rows of `columns` items.
    func rows<T>(of items: [T]) -> [[T]] {
        stride(from: 0, to: items.count, by: columns).map { Array(items[$0..<min($0 + columns, items.count)]) }
    }
}
