//
//  ProfileImage.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import SwiftUI

/// The profile image of a user, or a placeholder when there is none.
struct ProfileImage: View {
    let url: String?

    var body: some View {
        AsyncImage(url: url.flatMap(URL.init(string:))) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            Image("iconAvatar").resizable().scaledToFill()
        }
        .clipShape(Circle())
    }
}
