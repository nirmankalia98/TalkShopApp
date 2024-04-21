//
//  FeedTableViewCell.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 19/04/24.
//

import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func didTapOnUser(index: IndexPath?)
    func didLikePost(didLike: Bool, index: IndexPath?)
    func clickOnVideo(index: IndexPath?, seekTime: Double)
}

class FeedTableViewCell: UITableViewCell, NibLoadable {

    // MARK: IBOutlets
    @IBOutlet private weak var userProfileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var heartImageView: UIImageView!
    @IBOutlet private weak var likesCountLabel: UILabel!
    @IBOutlet private weak var feedVideoPlayer: FeedVideoPlayerView!
    @IBOutlet private weak var likeButton: ToggleButton!
    
    private var indexPath: IndexPath?
    private weak var delegate: FeedTableViewCellDelegate?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.userProfileImageView.backgroundColor = .lightGray
        self.userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.height/2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.likeButton.stateChanged = nil
        self.feedVideoPlayer.clear()
    }
    
    func setupCell(with data: FeedData, indexPath: IndexPath, delegate: FeedTableViewCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        self.userNameLabel.text = data.username
        let likes = data.likes ?? 0
        self.likesCountLabel.text = "\(likes) likes"
        self.likeButton.toggleText = "\(likes  + 1) likes"
        self.likeButton.untoggleTet = "\(likes) likes"
        self.likeButton.stateChanged = nil
        self.likeButton.isToggled = false
        self.userProfileImageView.setImageView(url: data.userImageUrl ?? "")
        self.feedVideoPlayer.configure(videoURL: data.videoURL ?? "", thumbnailURL: data.thumbnailURL ?? "")
        setGestures()
    }
    
    func play() {
        self.feedVideoPlayer.play()
    }
    
    func pause() {
        self.feedVideoPlayer.pause()
    }
    
    private func getPlayedTime() -> Double {
        return feedVideoPlayer.time
    }
    
    private func setGestures() {
        self.likeButton.stateChanged = {[weak self] didLike in
            self?.delegate?.didLikePost(didLike: didLike, index: self?.indexPath)
        }
        
        let profileGesture = UITapGestureRecognizer(target: self, action: #selector(userTapAction))
        self.userNameLabel.addGestureRecognizer(profileGesture)
        self.userProfileImageView.addGestureRecognizer(profileGesture)
        self.feedVideoPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapAction)))
    }
    
    @objc func userTapAction() {
        self.delegate?.didTapOnUser(index: indexPath)
    }
    
    @objc func viewTapAction() {
        self.delegate?.clickOnVideo(index: indexPath, seekTime: self.getPlayedTime())
    }
}
