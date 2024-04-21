//
//  PostViewController.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 19/04/24.
//

import UIKit

final class PostViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var videoPlayer: OverlayVideoPlayerView!
    @IBOutlet weak var likeButton: ToggleButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var playButton: ToggleButton!
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var speakerButton: ToggleButton!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loader: AnimatableButton!
    private let debouncer = Debouncer(interval: 1)

    private var viewModel: PostViewViewModel
    init(viewModel: PostViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        UINavigationBar.appearance().standardAppearance = appearance
        let item = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backButtonPressed))
        item.tintColor = .white
        self.navigationItem.leftBarButtonItem = item
        self.viewModel.delegate = self
        self.viewModel.fetchData()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.videoPlayer.clear()
    }
    
}

// MARK: private methods
private extension PostViewController {
    
    func setupUI() {
        videoPlayer.configure(videoURL: viewModel.videoUrl ?? "", delegate: self)
        speakerButton.stateChanged = { [weak self] isSpeaker in
            self?.videoPlayer.setMute(isMuted: !isSpeaker)
        }
        speakerButton.isToggled = true
        likeButton.stateChanged = { didLike in
            self.viewModel.didLikePost(liked: didLike)
        }
        self.playButton.isToggled = false
        playButton.stateChanged = { [weak self] didPause in
            if didPause {
                self?.videoPlayer.pause()
            } else {
                self?.videoPlayer.play()
            }
        }
        self.shareButton.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        self.profilePic.setImageView(url: viewModel.userPorfileUrl ?? "")
        self.userNameLabel.text = viewModel.userName
        self.timelineSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.loader.setup()
        // as we data is being passed on from Feeds commenting the loader otherwise will be used for loading state in Post
//        self.loader.startAnimating()
    }
    
    @objc private func backButtonPressed(_ sender: UIBarItem) {
        self.navigationController?.popViewController(animated: true)
     }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        self.videoPlayer.seek(to: sender.value)
     }
    
    @objc private func shareButtonPressed(_ sender: UIButton) {
        self.shareText(text: viewModel.videoUrl ?? "")
     }
}

extension PostViewController: VideoPlayerDelegate {
    func updateRemaingTime(timeInseconds: Float, durationInSeconds: Float) {
        durationLabel.text = TimeFormater.formatTime(seconds: timeInseconds)
        timelineSlider.maximumValue = durationInSeconds
        timelineSlider.value = timeInseconds
    }

    func didFailWith(error: String) {
        self.showAlert(title: "Error", msg: "Failed to play video")
    }
    
    func updateBufferState(isBuffering: Bool) {
        self.debouncer.debounce { [weak self] in
            if isBuffering {
                self?.loader.startAnimating()
            } else {
                self?.loader.stopAnimating()
            }
        }
    }
    
    func isReadyToPlay() {
        self.videoPlayer.seek(to: Float(viewModel.seekTime))
    }
}

extension PostViewController: PostViewViewModelDelegate {
    func reloadViews() {
        self.setupUI()
    }
}
