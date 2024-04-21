//
//  OverlayVideoPlayerView.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 19/04/24.
//

import Foundation
import UIKit
import AVFoundation


protocol VideoPlayerDelegate: AnyObject {
    func updateRemaingTime(timeInseconds: Float, durationInSeconds: Float)
    func didFailWith(error: String)
    func updateBufferState(isBuffering: Bool)
    func isReadyToPlay()
}


/// String enums for AVPlayerItem observation
enum AVPlayerKVO: String {
    case status
    case loadedTimeRanges
    case playbackBufferEmpty
    case playbackLikelyToKeepUp
    case duration
    case presentationSize
    case error
    case timeControlStatus
}

/// `OverlayVideoPlayerView` is used as just video player view with no other fuctionality. All the required functionality is handled by the delegate. Such as handling play/pause, seek time, volume, buffering etc.
final class OverlayVideoPlayerView: UIView {
    
    
    // MARK: - Properties
    weak var delegate: VideoPlayerDelegate?
    var isMute: Bool? {
        self.player?.isMuted
    }
    var time: Double {
        guard let currnetTime = self.player?.currentItem?.currentTime() else { return 0 }
        let time = CMTimeGetSeconds(currnetTime)
        return time
    }

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var isObserving: Bool = false
    private var isSeeking = false
    private var debouncer = Debouncer(interval: 0.2)
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initalize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initalize()
    }
    
    func initalize() {
        setupPlayerLayer()
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            if self?.isSeeking == false {
                self?.updateTime()
            }
        }
    }
    
    private func updateTime() {
        guard let currentTime = player?.currentTime(), let duration = player?.currentItem?.duration else {
            return
        }
        let remainingTime = CMTimeGetSeconds(currentTime)
        let durationSeconds = CMTimeGetSeconds(duration)
        self.delegate?.updateRemaingTime(timeInseconds: Float(remainingTime), durationInSeconds: Float(durationSeconds))
    }
    
    private func setupPlayerLayer() {
        playerLayer = AVPlayerLayer()
        layer.addSublayer(playerLayer!)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
//        [AVLayerVideoGravity.resizeAspectFill, AVLayerVideoGravity.resizeAspect].randomElement()! as AVLayerVideoGravity
    }
    
    // MARK: - Configuration
    func configure(videoURL: String, delegate: VideoPlayerDelegate) {
        guard let videoURL = URL(string: videoURL) else {
            return
        }
        self.delegate = delegate
        
        // Configure the video
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer?.player = player
        addObserversForBuffering()
        addPeriodicTimeObserver()
    }
    
    private func addObserversForBuffering() {
        self.isObserving = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)

        NotificationCenter.default.addObserver(forName: .AVPlayerItemPlaybackStalled, object: player?.currentItem, queue: .main) { [weak self] _ in
            self?.handleBuffering()
        }
        player?.currentItem?.addObserver(self, forKeyPath: AVPlayerKVO.timeControlStatus.rawValue, options: [.old, .new], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: AVPlayerKVO.error.rawValue, options: [.old, .new], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: AVPlayerKVO.status.rawValue, options: [.old, .new], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: AVPlayerKVO.playbackBufferEmpty.rawValue, options: [.old, .new], context: nil)
        player?.currentItem?.addObserver(self, forKeyPath: AVPlayerKVO.playbackLikelyToKeepUp.rawValue, options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        
        switch AVPlayerKVO(rawValue: keyPath ?? "") {
        case .status:
            if playerItem.status == .failed {
                self.displayError("Failed to load video")
            } else if playerItem.status == .readyToPlay {
                self.delegate?.isReadyToPlay()
            }
        case .playbackBufferEmpty, .playbackLikelyToKeepUp:
            handleBuffering()
        case .timeControlStatus:
            if player?.timeControlStatus == .playing {
                self.delegate?.updateBufferState(isBuffering: false)
            } else {
                handleBuffering()
            }
        case .error:
            self.displayError(playerItem.error?.localizedDescription ?? "")
        default:
            break
        }
    }
    
    private func handleBuffering() {
        if let player = player, player.currentItem?.isPlaybackLikelyToKeepUp == false {
            self.delegate?.updateBufferState(isBuffering: true)
        } else {
            self.delegate?.updateBufferState(isBuffering: false)
        }
    }
    
    private func displayError(_ message: String) {
        self.delegate?.didFailWith(error: message)
    }
        
    @objc private func playerItemDidReachEnd(notification: Notification) {
        if isSeeking == false {
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    func clear() {
        self.playerLayer?.removeFromSuperlayer()
        self.player = nil
        self.playerLayer = nil
        self.delegate = nil
    }
    
    // MARK: - Deinitialization
    deinit {
        guard isObserving == true, let item = player?.currentItem else { return }
        item.removeObserver(self, forKeyPath: AVPlayerKVO.timeControlStatus.rawValue)
        item.removeObserver(self, forKeyPath: AVPlayerKVO.error.rawValue)
        item.removeObserver(self, forKeyPath: AVPlayerKVO.status.rawValue)
        item.removeObserver(self, forKeyPath: AVPlayerKVO.playbackBufferEmpty.rawValue)
        item.removeObserver(self, forKeyPath: AVPlayerKVO.playbackLikelyToKeepUp.rawValue)
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: Public methods
extension OverlayVideoPlayerView {
    // MARK: - Playback Controls
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func toggleMute() {
        guard let player = player else { return }
        player.isMuted.toggle()
    }
    
    func setMute(isMuted: Bool) {
        guard let player = player else { return }
        player.isMuted = isMuted
    }

    func seek(to time: Float) {
        let newTime = CMTime(seconds: Double(time), preferredTimescale: 600)
        player?.seek(to: newTime)
        self.isSeeking = true
        debouncer.debounce { [weak self] in
            self?.isSeeking = false
        }
        
    }
}

