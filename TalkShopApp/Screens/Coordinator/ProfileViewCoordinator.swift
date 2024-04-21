//
//  ProfileViewCoordinator.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation
import UIKit

class ProfileViewCoordinator: Coordinator, ChildCoordinator {
    var parent: ParentCoordinator?
    
    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
    
    var viewControllerRef: UIViewController?
    
    var navigationController: UINavigationController
    private var profileData: ProfileInfo
    
    init(navigationController: UINavigationController, profileInfo: ProfileInfo) {
        self.navigationController = navigationController
        self.profileData = profileInfo
    }
    
    func start(animated: Bool) {
        let service = ProfileService()
        let vm = ProfileViewModel(userId: self.profileData.userId ?? "", profileData: self.profileData, service: service)
        let vc = ProfileViewController(viewModel: vm)
        vc.profileViewCoordinator = self
        self.viewControllerRef = vc
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func moveToPost(post: UserPost, profile: ProfileInfo) {
        let service = PostViewService()
        let vm = PostViewViewModel(post: post, profileInfo: profile, service: service)
        let vc = PostViewController(viewModel: vm)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
