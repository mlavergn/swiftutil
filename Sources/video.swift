/// Video class that encapsulates iOS / macOS video capture
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation

#if os(iOS)
import UIKit
#endif

import AVFoundation

// MARK: - Video class
public class Video: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {

	public var captureOutput: AVCaptureVideoDataOutput {
		let captureOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
		captureOutput.alwaysDiscardsLateVideoFrames = true

		captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]

		//  we don't need a high frame rate. this limits the capture to 5 frames per second.
		// captureOutput.minFrameDuration = CMTimeMake(1, 5);
		// AVCaptureConnection.videoMinFrameDuration

		//  we need a serial queue for the video capture delegate callback
		let queue = Dispatch.customQueue(name: "com.apple.avqueue")
		//		dispatch_queue_t queue = dispatch_queue_create("com.bunnyherolabs.vampire", NULL);

		captureOutput.setSampleBufferDelegate(self, queue: queue)

		//		dispatch_release(queue);

		return captureOutput
	}

	public func captureOutput(_: AVCaptureOutput, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)
		if let pixelBuffer = pixelBuffer {
			if CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly) == kCVReturnSuccess {
				CVPixelBufferGetBaseAddress(pixelBuffer)

				CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.readOnly)
			}
		}
	}

	public func captureInput(device: AVCaptureDevice) -> AVCaptureDeviceInput? {
		do {
			let captureInput: AVCaptureDeviceInput = try AVCaptureDeviceInput.init(device: device)
			return captureInput
		} catch {
			return nil
		}
	}

	/// Obtain an AVCaptureDevice
	public var captureDevice: AVCaptureDevice? {
		var captureDevice: AVCaptureDevice?
		#if os(iOS)
            let ddSession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video,
			                                                   position: AVCaptureDevice.Position.front)
            for device: AVCaptureDevice in ddSession.devices where device.position == AVCaptureDevice.Position.front {
                captureDevice = device
                break
            }
		#else
            captureDevice = AVCaptureDevice.default(for: .video)
		#endif

		return captureDevice
	}

	public var captureSession: AVCaptureSession {
		let captureSession: AVCaptureSession = AVCaptureSession()

		return captureSession
	}

	public func startCapture(captureSession: AVCaptureSession, output: AVCaptureVideoDataOutput) {
		captureSession.addOutput(output)
		captureSession.startRunning()
	}
}
