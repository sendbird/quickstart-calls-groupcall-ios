//
//  String+QuickStart.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/03/24.
//

import Foundation

extension String {
    public var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var isEmptyOrWhitespace: Bool {
        return trimmed.isEmpty
    }
    
    public var collapsed: String? {
        if isEmptyOrWhitespace {
            return nil
        } else {
            return trimmed
        }
    }
}
