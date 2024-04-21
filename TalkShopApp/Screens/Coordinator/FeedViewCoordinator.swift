//
//  FeedViewCoordinator.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import UIKit

class FeedViewCoordinator: Coordinator, ParentCoordinator {
    
    var childCoordinators: [ChildCoordinator] = []
    var viewControllerRef: FeedsViewController?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start(animated: Bool) {
        let feedsService = FeedsService()
        let viewModel = FeedsViewModel(service: feedsService)
        self.viewControllerRef = FeedsViewController(viewModel: viewModel)
        viewControllerRef?.feedsViewCoordinator = self
        navigationController.pushViewController(viewControllerRef!, animated: animated)
    }
    
    func moveToCurrentProfile() {
        let profileCoordinator = ProfileViewCoordinator(navigationController: navigationController, profileInfo: AppState.shared.currentUser)
        self.addChild(profileCoordinator)
        profileCoordinator.parent = self
        profileCoordinator.start(animated: true)
    }
    
    func moveToUserProfile(profile: ProfileInfo) {
        let profileCoordinator = ProfileViewCoordinator(navigationController: navigationController, profileInfo: profile)
        self.addChild(profileCoordinator)
        profileCoordinator.parent = self
        profileCoordinator.start(animated: true)
    }
    
    func moveToPost(data: FeedData, seekTime: Double) {
        let service = PostViewService()
        let profile = ProfileInfo(userId: data.userId, username: data.username, profilePictureURL: data.userImageUrl)
        let vm = PostViewViewModel(post: data, profileInfo: profile, seekTime: seekTime, service: service)
        let vc = PostViewController(viewModel: vm)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
