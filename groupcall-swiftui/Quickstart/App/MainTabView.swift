//
//  MainTabView.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SwiftUI

/// The main screen after signing in. The tabs show only icons, and the selected tab shows a filled icon.
struct MainTabView: View {
    private enum Tab {
        case rooms, settings
    }

    @State private var selection = Tab.rooms

    var body: some View {
        TabView(selection: $selection) {
            MainView()
                .tabItem { Image(selection == .rooms ? "iconRoomsFilled" : "iconRooms") }
                .tag(Tab.rooms)
            SettingsView()
                .tabItem { Image(selection == .settings ? "iconSettingsFilled" : "iconSettings") }
                .tag(Tab.settings)
        }
        .tint(.black)
    }
}
