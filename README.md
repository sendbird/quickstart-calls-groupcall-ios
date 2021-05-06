# iOS Group Call Quickstart for Sendbird Calls
![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)
![Languages](https://img.shields.io/badge/language-Swift-orange.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/sendbird/quickstart-calls-ios/blob/develop/LICENSE.md)

## Introduction

Sendbird Calls SDK for iOS is used to initialize, configure, and build voice and video calling functionality into your iOS client app. In this repository, you will find the steps you need to take before implementing the Calls SDK into a project, and a sample app which contains the code for implementing voice and video call. 

This readme explains the key functions of **group calls** consisting of how to create, delete a room and how a user can participate in a group call by entering and leaving a room from your client app.

> Note: You can only integrate one Sendbird application per app for your service regardless of the platforms. All users within your Sendbird application can communicate with each other across all platforms. This means that your iOS, Android, and web client app users can all make and receive calls with one another without any further setup. Note that all data is limited to the scope of a single application, and users in different Sendbird applications can't make and receive calls to each other.

### More about Sendbird Calls for iOS

Find out more about Sendbird Calls for iOS on [Calls for iOS doc](https://sendbird.com/docs/calls/v1/ios/getting-started/about-calls-sdk). If you need any help in resolving any issues or have questions, visit [our community](https://community.sendbird.com).

<br />

## Before getting started

This section shows you the prerequisites you need for testing Sendbird Calls for iOS sample app.

### Requirements

The minimum requirements for Calls SDK for iOS sample are: 

- Mac OS with developer mode enabled
- Xcode
- [Git Large File Storage](https://git-lfs.github.com/)
- Homebrew
- At least one physical iOS device running iOS 9.0 and later 

For more details on installing and configuring the Calls SDK for iOS, refer to [Calls for iOS docs](https://st.sendbird.com/docs/calls/v1/ios/getting-started/install-calls-sdk).

<br />

## Getting started

If you would like to try the sample app specifically fit to your usage, you can do so by following the steps below. 

### Create a Sendbird application

 1. Login or Sign-up for an account on [Sendbird Dashboard](https://dashboard.sendbird.com).
 2. Create or select a call-activated application on the dashboard.
 3. Keep your Sendbird application ID in a safe place for future reference. 

### Create test users

 1. On the Sendbird dashboard, navigate to the **Users** menu.
 2. Create at least two new users: one as a `caller`, and the other as a `callee`.
 3. Note the `user_id` of each user for future reference.

### Specify the Application ID

As shown below, the `SendBirdCall` instance must be initiated when a sample client app is launched. To initialize the sample with your Sendbird application, go to the Sendbird dashboard, create a Sendbird application, and then specify the `APP_ID` inside the sample app’s source code. 

In the source code, find the `application(_:didFinishLaunchingWithOptions:)` method from `AppDelegate.swift`. Replace `SAMPLE_APP_ID` with `APP_ID` of your Sendbird application created earlier.
 
```swift
SendBirdCall.configure("SAMPLE_APP_ID")
```
 
### Install and run the sample app

1. Verify that Xcode is open on your Mac system and the sample app project is open. 
2. Plug the primary iOS device into the Mac running Xcode
3. Unlock the iOS device
4. Run the application by pressing the `▶` **Run** button or typing `⌘+R`
5. Open the newly installed app on the iOS device
6. If two iOS devices are available, repeat these steps to install the sample app on each device.

<br />

# Making group calls
## Create a room

You can choose to create a room that supports up to 6 participants with video or a room that supports up to 25 participants with audio. When a user creates a room in your client app, the room’s status becomes `OPEN` and a `roomId` is generated.

You can create a room by setting the room type by using the `Type` property and the `createRoom()` method as shown below.

```swift
let roomType = RoomType.smallRoomForVideo
let params = RoomParams(roomType: roomType)
SendBirdCall.createRoom(with: params) { room, error in
	guard let room = room, error == nil else { return } // Handle error.
	// `room` is created with a unique identifier `room.roomId`.
}
```

|Property|Description|
|---|---|
|type|**Type: RoomType**<br />Specifies the type of the room. Valid values are limited to the following: <br />- **smallRoomForVideo**: type of a room that supports audio and video, can have up to 6 participants. <br />- **largeRoomForAudioOnly**: type of a room that only supports audio, can have up to 25 participants.|

>__Note__: To delete a room, you have to do so explicitly through platform API which will be provided soon.

## Enter a room

A user can search the room with `roomId` to participate in a group call at any time. When a user enters a room, a participant is created with a unique `participantId` to represent the user in the room.

To enter a room, you must acquire the room instance from Sendbird server using the `roomId` of the room. To fetch the most up-to-date room instance from Sendbird server, use the `SendBirdCall.fetchRoom(by:completionHandler:)` method. Also, you can use the `SendBirdCall.getCachedRoom(by:)` method that returns the most recently cached room instance from Sendbird Calls SDK.

```swift
SendBirdCall.fetchRoom(by: ROOM_ID) { room, error in
	guard let room = room, error == nil else { return } // Handle error.
	// `room` with the identifier `ROOM_ID` is fetched from Sendbird Server.
} // Fetches a room with the given room ID from the server.
let cachedRoom: Room? = SendBirdCall.getCachedRoom(by: ROOM_ID)
// Returns the most recently cached room from the SDK.
//If there is no such room with the given room ID, `nil` is returned.
```

>__Note__: When a user enters a room with multiple devices, a new participant for the same user will be created for each device or browser tab.
Once the room is retrieved, call the `enter(with:completionHandler:)` method to enter the room.

```swift
let params = RoomEnterParams(isVideoEnabled: true, isAudioEnabled: true)
room.enter(with: params) { room, error in
	guard let room = room, error == nil else { return } // Handle error.
	// User has successfully entered `room`.
}
```

>__Note__: As of now, you have to share the `roomId` with other users for them to enter the room for group calls.

## Exit a room

To leave a room, call `Room.exit()`. On the room delegates of the remaining participants, the `RoomDelegate.didRemoteParticipantExit(_:)` method will be called.

```swift
do {
	try room.exit()
	// participant has exited the room successfully.
} catch {
	// SBCError.participantNotInRoom is thrown because participant has not entered the room.
}
```

## Interact within a room

Participant’s actions, such as turning on or off their microphone or camera, in a room are handled by the participant objects.

To control the media of the local user, you can use the following methods from the `Room.localParticipant` object:

```swift
// Mutes the microphone of the local participant.
room.localParticipant.muteMicrophone()
// Unmutes the microphone of the local participant.
room.localParticipant.unmuteMicrophone()
// Stops the local participant's video.
room.localParticipant.stopVideo()
// Starts the local participant's video.
room.localParticipant.startVideo()
// Switches between the front and back camera.
room.localParticipant.switchCamera(completionHandler: ErrorHandler)
```

## Display video view

When there is a participant in the room, a media stream is established between a participant and Sendbird server to support group calls. You can configure the user interface for participants in a room by using the properties in `Participant`.

### Receive media stream

The following is the process of how participants can send and receive media streams in a room:

**Step 1**: To send a media stream, a participant who would like to send its media stream has to be connected to Sendbird server.

**Step 2**: To receive a media stream, a participant who would like to receive a media stream from another participant has to be connected to the media server. Once connected, the `didRemoteParticipantStreamStart(_:)` method will be invoked which notifies that the receiving media stream has started.

**Step 3**: Add a view to show the received media stream.

```swift
class MyClass: RoomDelegate {
	// Called when a remote participant is connected to the media stream and starts sending the media stream.
	func didRemoteParticipantStreamStart(_ participant: RemoteParticipant) { }
}
```

You can receive a video stream from a participant by configuring the `videoView` property as shown below:

```swift
@IBOutlet weak var participantVideoView: UIView?
// Create SendBirdVideoView.
let participantSendBirdVideoView = SendBirdVideoView(frame: self.participantVideoView?.frame ?? CGRect.zero)
self.participantVideoView?.embed(participantSendBirdVideoView)
// Configure participants video view.
// participant: Participant
participant.videoView = participantSendBirdVideoView
```

### Manage video layout

You can show participants in gallery view as they enter or exit the room by using [`UICollectionView`](https://developer.apple.com/documentation/uikit/uicollectionview) which dynamically changes views. You can set the number of items to be the count of `room.participants` and the custom cells to represent a participant.

When the below methods in `RoomDelegate` are called, information for `room.participants` gets updated and the number of items are changed accordingly. To have the custom cells added or removed, you need to call `UICollectionView.reloadData()` for the delegate methods.

<div component="AdvancedTable" type="2A">

|Method|Description|
|---|---|
|didRemoteParticipantEnter(_ participant: RemoteParticipant)|Invoked when a remote participant has entered a room.|
|didRemoteParticipantExit(_ participant: RemoteParticipant)|Invoked when a remote participant has exited a room.|
|didRemoteParticipantStreamStart(_ participant: RemoteParticipant)|Invoked when a remote participant has started media streaming.|
|didRemoteAudioSettingsChange(_ participant: RemoteParticipant)|Invoked when a remote partcipant's audio settings have changed.|
|didRemoteVideoSettingsChange(_ participant: RemoteParticipant)|Invoked when a remote participant's video settings have changed.|

### Show default image for user

If a participant is not connected to the call or has turned off their video, you can set an default image to show on the screen for that participant whose view will otherwise be shown as black to other participants. To check whether a participant has turned on their video or is connected to the room for a video call, refer to the `isVideoEnabled` and the `state` properties of a `Participant` object.

It is recommended to show an image such as the user’s profile image as the default image when the `didRemoteParticipantEnter(_:)` delegate method is invoked.

When the `didRemoteParticipantStreamStart(_:)` delegate method is invoked, create a new `UIImageView` and set it to the participant by adding it as a subview on the `UITableView` or `UICollectionView` cell.

## Handle events in a room

A user can receive events such as other participants entering or leaving the room or changing their media settings only about a room that the user currently participates in.

### Add event delegate

Add an event delegate for the user to receive events that occur in a room that the user joins as a participant.

```swift
room.addDelegate(myClass, identifier: UNIQUE_IDENTIFIER)
class MyClass: RoomDelegate {
}
```

### Receive events on enter and exit

When a participant joins or leaves the room, other participants in the room will receive the following events.

```swift
class MyClass: RoomDelegate {
	// Called when a remote participant has entered the room.
	func didRemoteParticipantEnter(_ participant: RemoteParticipant) { }
	// Called when a remote participant has exited the room.
	func didRemoteParticipantExit(_ participant: RemoteParticipant) { }
}
```

### Receive events on media setting

A local participant can change the media settings such as muting their microphone or turning off their camera using `muteMicrophone()` or `stopVideo()`. Other participants will receive event delegates that notify them of the corresponding media setting changes.

```swift
class MyClass: RoomDelegate {
 // Called when audio settings of a remote participant have been changed.
	func didRemoteAudioSettingsChange(_ participant: RemoteParticipant) { }
	// Called when video settings of a remote participant have been changed.
	func didRemoteVideoSettingsChange(_ participant: RemoteParticipant) { }
}
```

### Remove event delegate

To stop receiving events about a room, remove the registered delegates as shown below:

```swift
// Removes registered delegate that has the matching identifier.
room.removeDelegate(identifier: UNIQUE_IDENTIFIER)
// Removes all registered delegates to stop receiving events about a room.
room.removeAllDelegates()
```

## Reconnect to media stream

When a participant loses media stream in a room due to connection issues, Sendbird Calls SDK automatically tries to reconnect the participant’s media streaming in the room. If the Calls SDK fails to reconnect for about 40 seconds, an error will be returned with the error code `SBCError.localParticipantLostConnection`.

```swift
class MyClass: RoomDelegate {
	// Called when an error has occurred.
	func didReceiveError(_ error: SBCError, participant: Participant?) {
		// Clear resources for group calls.
	}
}
```

>__Note__: See the [Error codes](/docs/calls/v1/platform-api/guides/error-codes) page for more information.

<br />

## Reference

For further detail on Group Calls, refer to [Group Call for iOS Docs](https://st.sendbird.com/docs/calls/v1/ios/guides/group-calls).
