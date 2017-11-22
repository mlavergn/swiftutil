/// Audio class that encapsulates iOS / macOS audio functionality
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT

import Foundation
import AVFoundation

public struct Audio {
	public static func allowBackgroundAudio() {
		#if os(iOS)
			do {
				// avoid stopping background music
				try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
			} catch {
				Log.error("Unable to instantiate AVAudioSession")
				return
			}
		#endif
	}

	public static func volume() -> Float {
		var result: Float = 0.0
		#if os(iOS)
			result = AVAudioSession.sharedInstance().outputVolume
		#else
			let deviceID = defaultAudioDevice()
            var dataSize = UInt32(MemoryLayout<Float>.size)

			// get its sample rate
			var audioAddr: AudioObjectPropertyAddress = AudioObjectPropertyAddress()
			audioAddr.mSelector = kAudioDevicePropertyVolumeScalar
			audioAddr.mScope = kAudioObjectPropertyScopeOutput
			audioAddr.mElement = 1

			var outVolume: Float = 0
			let err = AudioObjectGetPropertyData(deviceID, &audioAddr, 0, nil, &dataSize, &outVolume)
			result = Float(outVolume)

			// if there is no error, outSampleRate contains the sample rate
			if err != kAudioHardwareNoError {
				Log.error("Unable to obtain volume")
			}
		#endif

		return result
	}

	public static func sampleRate() -> Double {
		var result: Double = 0.0
		#if os(iOS)
			result = AVAudioSession.sharedInstance().sampleRate
		#else
			let deviceID = defaultAudioDevice()
			var dataSize = UInt32(MemoryLayout<Float64>.size)

			// get its sample rate
			var audioAddr: AudioObjectPropertyAddress = AudioObjectPropertyAddress()
			audioAddr.mSelector = kAudioDevicePropertyNominalSampleRate
			audioAddr.mScope = kAudioObjectPropertyScopeGlobal
			audioAddr.mElement = kAudioObjectPropertyElementMaster

			var outSampleRate: Float64 = 0
			let err = AudioObjectGetPropertyData(deviceID, &audioAddr, 0, nil, &dataSize, &outSampleRate)
			result = outSampleRate

			// if there is no error, outSampleRate contains the sample rate
			if err != kAudioHardwareNoError {
				Log.error("Unable to obtain default sample rate")
			}
		#endif

		return result
	}

	#if os(macOS)
	public static func defaultAudioDevice() -> AudioObjectID {
		// get the default output device
		var audioAddr: AudioObjectPropertyAddress = AudioObjectPropertyAddress()
		audioAddr.mSelector = kAudioHardwarePropertyDefaultOutputDevice
		audioAddr.mScope = kAudioObjectPropertyScopeGlobal
		audioAddr.mElement = kAudioObjectPropertyElementMaster

		let systemDeviceID = AudioObjectID(bitPattern: kAudioObjectSystemObject)
		var dataSize = UInt32(MemoryLayout<AudioDeviceID>.size)
		var deviceID: AudioObjectID = 0
		let err = AudioObjectGetPropertyData(systemDeviceID, &audioAddr, 0, nil, &dataSize, &deviceID)
		if err != kAudioHardwareNoError {
			Log.error("Unable to obtain default output device")
		}

		return deviceID
	}
	#endif
}
