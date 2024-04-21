//
//  PostViewModel.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

protocol PostViewViewModelDelegate: AnyObject {
    func reloadViews()
    func showAlert(title: String, msg: String)
}

final class PostViewViewModel {
    
    private(set) var userPorfileUrl: String?
    private(set) var userName: String?
    private(set) var videoUrl: String?
    private(set) var seekTime: Double = 0

    private var post: Post
    private var service: PostViewServiceProtocol?
    private var profileInfo: ProfileInfo?
    private var discoveredData: DiscoveredPost?
    weak var delegate: PostViewViewModelDelegate?
    
    init(post: Post,
         profileInfo: ProfileInfo,
         seekTime: Double = 0,
         service: PostViewServiceProtocol) {
        self.userPorfileUrl = profileInfo.profilePictureURL
        self.userName = profileInfo.username
        self.profileInfo = profileInfo
        self.post = post
        self.service = service
        self.videoUrl = post.videoURL
        self.seekTime = seekTime
    }
    
    func fetchData() {
        self.service?.fetchPostData(by: "1234", completion: {[weak self] res in
            switch res {
            case .success(let postResponse):
                self?.handleDataRecived(feeds: postResponse.data)
            case .failure(let error):
                self?.delegate?.showAlert(title: "Error", msg: "Failed to load data")
                debugPrint("\(error)")
            }
        })
    }
    
    func didLikePost(liked: Bool) {
        guard let userId = profileInfo?.userId, let postId = post.postID else {
            debugPrint("Found null user Id")
            return
        }
        self.service?.sendLikeRequest(didLike: liked,by: userId, for: postId) { isSuccess in
            debugPrint("like sent status was success ? \(isSuccess)")
        }
    }
    
    private func handleDataRecived(feeds: DiscoveredPost?) {
        self.delegate?.reloadViews()
    }
}
