# iOS Group Call Quickstart for Sendbird Calls (SwiftUI)
![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/language-Swift-orange.svg)
![UI](https://img.shields.io/badge/UI-SwiftUI-blue.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/sendbird/quickstart-calls-ios/blob/develop/LICENSE.md)

## Introduction

This sample app shows how to build group voice and video calls in rooms with [Sendbird Calls SDK for iOS](https://github.com/sendbird/sendbird-calls-ios) in a SwiftUI app. Users create a room, share its ID, and enter it with the microphone and the camera on or off.

> Note: You can only integrate one Sendbird application per app for your service regardless of the platforms. All users within your Sendbird application can communicate with each other across all platforms. This means that your iOS, Android, and web client app users can all enter the same rooms without any further setup. Note that all data is limited to the scope of a single application, and users in different Sendbird applications can't enter each other's rooms.

Find out more about Sendbird Calls for iOS on [Calls for iOS doc](https://sendbird.com/docs/calls/v1/ios/getting-started/about-calls-sdk). If you need any help in resolving any issues or have questions, visit [our community](https://community.sendbird.com).

<br />

## Requirements

- Xcode 16 or later. The project uses folder-synchronized groups, which earlier versions of Xcode can't open.
- At least one physical iOS device running iOS 17.0 or later. The iOS Simulator can enter a room, but it has no camera.
- A Sendbird application with Calls enabled

The app installs [`SendBirdCalls`](https://github.com/sendbird/sendbird-calls-ios) with Swift Package Manager. Xcode resolves the package when you open the project.

<br />

## Getting started

### Create a Sendbird application

1. Log in or sign up for an account on [Sendbird Dashboard](https://dashboard.sendbird.com).
2. Create or select a call-activated application on the dashboard.
3. Keep your Sendbird application ID in a safe place for future reference.

### Create test users

1. On the Sendbird dashboard, navigate to the **Users** menu.
2. Create at least two new users to enter the same room.
3. Note the `user_id` of each user for future reference.

### Install and run the sample app

1. Open `Quickstart.xcodeproj` in this folder with Xcode.
2. In **Signing & Capabilities** of the `Quickstart` target, select your team.
3. Connect an iOS device, and run the `Quickstart` scheme.
4. If you have more devices, install the app on each of them.

The UIKit sample in [`groupcall-uikit/`](../groupcall-uikit) uses the same bundle identifier, `com.sendbird.calls.quickstart.rooms`. Install only one of them on a device at a time, and delete the installed one before you install the other. If you install the UIKit sample over this sample, the UIKit sample shows a black screen.

### Sign in

Enter the Sendbird application ID, a user ID, and an access token if your application requires one. The app configures Sendbird Calls with the application ID each time you sign in.

To always use your own application ID, call `SendBirdCall.configure(appId:)` with it in `AuthService.signIn(_:)`, and remove the application ID field from `SignInView`.

<br />

## Making your first group call

1. Sign in on the first device. Under **Create a call**, tap **Create**, enter a room title, and tap **Create** again. The app enters the new room and shows its room ID.
2. Copy or share the room ID.
3. Sign in on the second device as another user. Under **Enter with room ID**, enter the room ID, and tap **Enter**.
4. The preview screen shows your camera. Turn off the microphone or the camera if you want, and tap **Enter**.
5. Each participant's video shows in a grid. A room of the `smallRoomForVideo` type takes up to 6 participants.
6. If the devices are near each other, use headphones to prevent audio feedback.

<br />

## Where to find each feature

| Feature | File | Sendbird Calls API |
|---|---|---|
| Sign in and out | [`Auth/AuthService.swift`](Quickstart/Auth/AuthService.swift) | `SendBirdCall.configure(appId:)`, `authenticate(with:completionHandler:)`, `deauthenticate(completionHandler:)` |
| Create, fetch, and enter a room | [`Room/RoomService.swift`](Quickstart/Room/RoomService.swift) | `SendBirdCall.createRoom(with:completionHandler:)`, `fetchRoom(by:completionHandler:)`, `Room.enter(with:completionHandler:)` |
| Preview the camera before entering | [`Room/PreviewView.swift`](Quickstart/Room/PreviewView.swift), [`Room/CameraPreview.swift`](Quickstart/Room/CameraPreview.swift) | `RoomEnterParams` |
| Room state and controls | [`Room/RoomSession.swift`](Quickstart/Room/RoomSession.swift) | `RoomDelegate`, `LocalParticipant.muteMicrophone()`, `stopVideo()`, `switchCamera(completionHandler:)`, `Room.exit()` |
| Show participants' videos in SwiftUI | [`Room/ParticipantVideoView.swift`](Quickstart/Room/ParticipantVideoView.swift), [`Room/ParticipantTile.swift`](Quickstart/Room/ParticipantTile.swift) | `SendBirdVideoView`, `Participant.videoView` |
| Lay out the video grid | [`Room/ParticipantGrid.swift`](Quickstart/Room/ParticipantGrid.swift) | |
| Room title | [`Room/RoomInformationView.swift`](Quickstart/Room/RoomInformationView.swift), [`Room/ParticipantsView.swift`](Quickstart/Room/ParticipantsView.swift) | `Room.updateCustomItems(customItems:completionHandler:)`, `RoomDelegate.didUpdateCustomItems(updatedKeys:)` |
| Choose the audio output | [`Room/AudioRoutePicker.swift`](Quickstart/Room/AudioRoutePicker.swift) | `SendBirdCall.routePickerView(frame:)` |

<br />

## Using Sendbird Calls with SwiftUI

- **Read the room's state again on every room event.** `RoomSession` doesn't keep values that it read once. On each `RoomDelegate` event, and after each of the user's own actions, it reads the participants, their audio and video state, and the room title from the `Room` again.
- **Read the local participant after entering.** `Room.localParticipant` is `nil` until `enter(with:completionHandler:)` completes. The app creates `RoomSession` only for an entered room.
- **Add the room delegate when the room screen appears.** SwiftUI can create a view's initial state more than once, so `RoomSession` adds itself as a `RoomDelegate` in `start()`, which the room screen calls when it appears. `exit()` removes it.
- **Create each `SendBirdVideoView` once.** `ParticipantVideoView` creates the video view in `makeUIView(context:)` and never in `updateUIView(_:context:)`. `Participant.videoView` is a weak reference, so the SwiftUI view keeps the video view alive. To hide a video, cover it instead of removing the view.
- **Identify participants by `participantId`.** The video grid uses `participantId` as the identity of each tile, so the remaining participants' videos keep playing when someone enters or leaves. A user who enters from two devices becomes two participants.
- **Write `@SwiftUI.State` in files that also import SendBirdCalls.** SendBirdCalls has types named `State`, such as `Room.State` and `Participant.State`. Some versions of Xcode, such as Xcode 26, report `State` as ambiguous in a file that imports both modules.

### Differences from the UIKit sample

- **Your own video is mirrored while you use the front camera, like a mirror.** Sendbird Calls doesn't mirror the local video, so the UIKit sample shows your video flipped compared with its preview screen, which `AVCaptureVideoPreviewLayer` mirrors. This app mirrors only your own tile on the screen with `scaleEffect(x: -1, y: 1)`. The video that other participants receive doesn't change. Sendbird Calls doesn't tell the current camera position, so `RoomSession` keeps it in `isUsingFrontCamera`.
- **Your video is covered while the camera switches.** `LocalParticipant.switchCamera(completionHandler:)` calls its handler before the new camera's first frame arrives. If the app changed the mirroring then, the last frames of the previous camera would flip for a moment. So `RoomSession` covers your video, waits a little after the handler, and then changes the mirroring and shows your video again.

<br />

## Reference

For the Sendbird Calls APIs used in group calls, such as entering and leaving a room, handling room events, and reconnecting to the media stream, see [the UIKit sample's README](../groupcall-uikit/README.md#making-group-calls) and [Sendbird Calls SDK for iOS README](https://github.com/sendbird/sendbird-calls-ios/blob/master/README.md).
