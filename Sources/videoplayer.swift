/// VideoPlayer class that encapsulates iOS / macOS AVPlayer access
///
/// - author: Marc Lavergne <mlavergn@gmail.com>
/// - copyright: 2017 Marc Lavergne. All rights reserved.
/// - license: MIT
import AVFoundation

#if os(iOS)
import UIKit
public typealias View = UIView
#else
import AppKit
public typealias View = NSView
#endif
import AVFoundation

public class VideoPlayer {
	var frame: CGRect
	var player: AVPlayer?
	var completion: (() -> Void)?

	public init() {
		frame = CGRect()
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	private func urlIsReachable(url: URL) -> Bool {
		do {
			if url.isFileURL {
				_ = try url.checkResourceIsReachable()
			}
		} catch {
			Log.warn("Unable to reach URL \(url.absoluteString)")
			return false
		}

		return true
	}

	public func playBundleVideo(view: View, path: String!, completion: @escaping (() -> Void)) {
		guard let resourcePath = Bundle.main.path(forResource: path, ofType: "mp4") else {
			Log.error("Unable to find resource \(path) from Main bundle")
			completion()
			return
		}

		let url = URL(fileURLWithPath: resourcePath)

		if !urlIsReachable(url: url) {
			Log.error("Unable to create URL for resource \(resourcePath) from Main bundle")
			completion()
			return
		}

		playVideo(view: view, url: url, completion: completion)
	}

	public func playSystemVideo(view: View, path: String!, completion: @escaping (() -> Void)) {
		let url = URL(fileURLWithPath: path)

		if !urlIsReachable(url: url) {
			Log.error("Unable to create URL for resource \(path) from Main bundle")
			completion()
			return
		}

		playVideo(view: view, url: url, completion: completion)
	}

	public func playVideo(view: View, url: URL, completion: @escaping (() -> Void)) {
		Log.stamp()
		self.completion = completion

		Audio.allowBackgroundAudio()

		let asset = AVAsset(url: url)

		if asset.isPlayable == false {
			Log.warn("Unable to play asset \(url)")
			return
		}

		let playerItem = AVPlayerItem(asset: asset)
		player = AVPlayer(playerItem: playerItem)

		NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishPlaying(notification:)),
		                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)

		frame = view.bounds
		let playerLayer = AVPlayerLayer(player: player)
//		playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
		playerLayer.frame = frame
		playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		playerLayer.zPosition = -1

		#if os(iOS)
		view.layer.addSublayer(playerLayer)
		#else
		view.wantsLayer = true
		view.layer!.addSublayer(playerLayer)
		#endif

		playerLayer.setNeedsLayout()

		player?.seek(to:kCMTimeZero)
		player?.play()
	}

	public func pause() {
		player?.pause()
	}

	public func stop() {
		pause()
		player?.seek(to:kCMTimeZero)
	}

	public func seek(seconds: Float64) {
		player?.seek(to: CMTimeMakeWithSeconds(seconds, 60000))
	}

	public func screenGrab() -> Image? {
		let asset: AVAsset? = player?.currentItem?.asset
		let gen = AVAssetImageGenerator(asset: asset!)
		var capture: CGImage? = nil
		do {
			capture = try gen.copyCGImage(at: player!.currentTime(), actualTime:nil)
		} catch {
			Log.warn("Unable to capture screen")
			return nil
		}
		#if os(iOS)
		return Image(cgImage: capture!)
		#else
		return Image(cgImage: capture!, size: frame.size)
		#endif
	}

	@objc public func didFinishPlaying(notification: NSNotification) {
		Log.stamp()
		completion?()
	}
}
