//
//  FeedVideoPlayer.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 19/04/24.
//

import UIKit
import AVFoundation

class FeedVideoConfig {
    private init(){}
    private let muteImage = UIImage(systemName: "speaker.slash.fill")
    private let speakerImage = UIImage(systemName: "speaker.wave.3.fill")
    var speakerStateImage: UIImage? {
        isMute ? muteImage : speakerImage
    }
    static let shared = FeedVideoConfig()
    var isMute = true
 }

class FeedVideoPlayerView: UIView {
    
    // MARK: - Properties
    private var videoPlayer: OverlayVideoPlayerView?
    private var muteButton: UIButton?
    private var retryButton: UIButton?
    private var playButton: AnimatableButton?
    private var thumbnailImageView: UIImageView?
    private var timeRemainingLabel: UILabel?
    
    var time: Double {
        self.videoPlayer?.time ?? 0.0
    }
    
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
        setupMuteButton()
        setupErrorLabel()
        setupThumbnailImageView()
        setupTimeRemainingLabel()
        setupPlayButton()

        self.backgroundColor = .black
    }
    
    private func animatePlayButton() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.playButton?.alpha = 0
        }, completion: nil)
    }
    
    private func setupTimeRemainingLabel() {
        timeRemainingLabel = UILabel()
        timeRemainingLabel?.translatesAutoresizingMaskIntoConstraints = false
        timeRemainingLabel?.textColor = .white
        timeRemainingLabel?.font = UIFont.systemFont(ofSize: 12)
        addSubview(timeRemainingLabel!)
        NSLayoutConstraint.activate([
            timeRemainingLabel!.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            timeRemainingLabel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            timeRemainingLabel!.heightAnchor.constraint(equalToConstant: 20)
        ])
        timeRemainingLabel?.text = "0:00"
    }
    
    private func setupThumbnailImageView() {
        thumbnailImageView = UIImageView(frame: bounds)
        thumbnailImageView?.contentMode = .scaleAspectFill
        thumbnailImageView?.clipsToBounds = true
        thumbnailImageView?.isHidden = false
        addSubview(thumbnailImageView!)
        sendSubviewToBack(thumbnailImageView!)
    }
    
    private func setupPlayButton() {
        playButton = AnimatableButton()
        playButton?.setup()
        addSubview(playButton!)
    }
    
    private func setupPlayerLayer() {
        self.videoPlayer = OverlayVideoPlayerView()
        self.videoPlayer?.frame = bounds
        self.insertSubview(videoPlayer!, at: 0)
    }
    
    
    private func setupMuteButton() {
        muteButton = UIButton(type: .system)
        muteButton?.tintColor = .white
        muteButton?.setImage(FeedVideoConfig.shared.speakerStateImage, for: .normal)
        muteButton?.setTitle("", for: .normal)
        
        muteButton?.frame = CGRect(x: bounds.width - 70, y: bounds.height - 50, width: 24, height: 24)
        muteButton?.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
        if let button = muteButton {
            addSubview(button)
        }
    }
    
    private func setupErrorLabel() {
        retryButton = UIButton(frame: CGRect(x: 20, y: 20, width: bounds.width - 40, height: 50))
        retryButton?.setImage(UIImage(systemName: "arrow.circlepath"), for: .normal)
        retryButton?.titleLabel?.textColor = .white
        retryButton?.contentHorizontalAlignment = .center
        retryButton?.isHidden = true
        retryButton?.titleEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 12)
        self.tintColor = .white
        retryButton?.semanticContentAttribute = .forceRightToLeft
        
        if let label = retryButton {
            addSubview(label)
        }
        retryButton?.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
    }
    
    @objc private func retryButtonAction(sender: UIButton) {
        self.videoPlayer?.play()
    }
    
    func clear() {
        self.videoPlayer?.clear()
        self.videoPlayer = nil
    }
    
    // MARK: - Configuration
    func configure(videoURL: String, thumbnailURL: String?) {
        // Load the thumbnail
        self.setupPlayerLayer()
        loadThumbnail(from: thumbnailURL)
        // Configure the video
        self.videoPlayer?.configure(videoURL: videoURL, delegate: self)
    }
    
    private func loadThumbnail(from url: String?) {
        guard let url = url, let validUrl = URL(string: url) else {
            debugPrint(#function,"invalid url \(url)")
            return
        }
        ImageLoader.shared.request(url, completion: { [weak self] imageRes in
            switch imageRes {
            case .success(let image):
                self?.thumbnailImageView?.image = image
            case .failure(let err):
                debugPrint(#function,err)
            }
        })
    }
    
    
    private func handleBuffering(isBuffering: Bool) {
        if isBuffering {
            playButton?.startAnimating()
        } else {
            playButton?.stopAnimating()
        }
    }
    
    private func displayError(_ message: String) {
        retryButton?.frame = CGRect(x: 20, y: bounds.midY - 25, width: bounds.width - 40, height: 50)
        thumbnailImageView?.animate(hidden: true)
        retryButton?.setTitle(message, for: .normal)
        retryButton?.isHidden = false
    }
    
    @objc private func toggleMute() {
        self.videoPlayer?.toggleMute()
        FeedVideoConfig.shared.isMute = self.videoPlayer?.isMute ?? true
        muteButton?.setImage(FeedVideoConfig.shared.speakerStateImage , for: .normal)
        muteButton?.setTitle("", for: .normal)
    }
        
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayer?.frame = bounds
        muteButton?.frame = CGRect(x: bounds.width - 70, y: bounds.height - 50, width: 60, height: 30)
        playButton?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        retryButton?.frame = CGRect(x: 20, y: bounds.midY - 25, width: bounds.width - 40, height: 50)
        thumbnailImageView?.frame = bounds
    }
    
    deinit {
        self.videoPlayer = nil
    }
}

extension FeedVideoPlayerView: VideoPlayerDelegate {
    func updateRemaingTime(timeInseconds: Float, durationInSeconds: Float) {
        let remainingTime = durationInSeconds - timeInseconds
        timeRemainingLabel?.text = TimeFormater.formatTime(seconds: remainingTime)
    }
    
    func didFailWith(error: String) {
        self.displayError("Retry")
    }
    
    func updateBufferState(isBuffering: Bool) {
        self.handleBuffering(isBuffering: isBuffering)
    }
    
    func isReadyToPlay() {
        self.thumbnailImageView?.animate(hidden: true)
        self.videoPlayer?.setMute(isMuted: FeedVideoConfig.shared.isMute)
    }
}

extension FeedVideoPlayerView {
    func play() {
        self.thumbnailImageView?.animate(hidden: true)
        self.videoPlayer?.isHidden = false
        self.videoPlayer?.play()
    }
    
    func pause() {
        self.thumbnailImageView?.animate(hidden: false)
        self.videoPlayer?.isHidden = true
        self.videoPlayer?.pause()
    }
}
