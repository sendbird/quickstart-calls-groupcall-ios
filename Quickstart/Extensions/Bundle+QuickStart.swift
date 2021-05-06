//
//  Bundle+QuickStart.swift
//  Quickstart
//
//  Created by Minhyuk Kim on 2021/04/02.
//

import Foundation

extension Bundle {
    var appName: String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let infoDict = NSDictionary.init(contentsOfFile: path),
           let appName = infoDict["CFBundleName"] as? String {
            return appName
        }
        return nil
    }
    
    var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
