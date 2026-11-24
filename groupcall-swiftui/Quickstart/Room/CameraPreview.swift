//
//  CameraPreview.swift
//  Quickstart
//
//  Copyright © 2026 Sendbird Inc. All rights reserved.
//

import AVFoundation
import SwiftUI

/// Shows the front camera before entering a room, without Sendbird Calls.
///
/// `AVCaptureVideoPreviewLayer` mirrors the front camera by itself.
struct CameraPreview: UIViewRepresentable {
    final class PreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var previewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
        let session = AVCaptureSession()

        func start() {
            guard session.inputs.isEmpty else { return }
            session.sessionPreset = .vga640x480
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
               let input = try? AVCaptureDeviceInput(device: device),
               session.canAddInput(input) {
                session.addInput(input)
            }
            previewLayer.session = session
            previewLayer.videoGravity = .resizeAspectFill
            // `startRunning()` blocks until the camera starts, so call it off the main thread.
            let session = session
            DispatchQueue.global(qos: .userInitiated).async { session.startRunning() }
        }

        func stop() {
            let session = session
            DispatchQueue.global(qos: .userInitiated).async { session.stopRunning() }
        }
    }

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.start()
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) { }

    static func dismantleUIView(_ uiView: PreviewView, coordinator: ()) {
        uiView.stop()
    }
}
