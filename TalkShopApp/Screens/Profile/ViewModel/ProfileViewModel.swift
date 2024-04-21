//
//  ProfileViewModel.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation


enum ProfileViewSection: Int, CaseIterable {
    case details = 0
    case posts
    
    static var totalSections: Int {
        Self.allCases.count
    }
}

protocol ProfileViewModelDelegate: AnyObject {
    func reloadData()
    func showAlert(title: String, msg: String)
}

final class ProfileViewModel {
    
    private(set) var userName: String
    private(set) var bio: String = "Talk Shop User"
    var postCount: Int {
        self.profileData?.posts.count ?? 0
    }
    private(set) var profileImageUrl: String
    private var profileData: ProfileData?
    private var userId: String
    private var service: ProfileServiceProtocol
    weak var delegate: ProfileViewModelDelegate?
    init(userId: String, profileData: ProfileInfo, service: ProfileServiceProtocol) {
        self.service = service
        self.userId = userId
        self.userName = profileData.username ?? ""
        self.profileImageUrl = profileData.profilePictureURL ?? ""
    }
    
    func fetchData() {
        self.service.fetchProfileData(userId: userId) { [weak self] res in
            switch res {
            case .success(let profile):
                self?.profileData = profile.data
                self?.delegate?.reloadData()
            case .failure(let err):
                self?.delegate?.showAlert(title: "Erorr", msg: "Failed to load data")
                break
            }
        }
    }
}

extension ProfileViewModel {
    func numberOfItems(for section: Int) -> Int {
        switch ProfileViewSection(rawValue: section) {
        case .details:
            return 1
        case .posts:
            return self.postCount
        default:
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        return ProfileViewSection.totalSections
    }
    
    func post(at index: Int) -> UserPost? {
        self.profileData?.posts[safe: index]
    }
}
