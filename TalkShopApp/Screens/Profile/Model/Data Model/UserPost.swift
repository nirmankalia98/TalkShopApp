//
//  Post.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import Foundation

// MARK: - ProfileResponse
struct ProfileResponse: Codable {
    let status: String
    let data: ProfileData?
}

// MARK: - DataClass
struct ProfileData: Codable {
    let userId: String?
    let username: String?
    let profilePictureURL: String?
    let posts: [UserPost]

    enum CodingKeys: String, CodingKey {
        case username
        case profilePictureURL = "profilePictureUrl"
        case posts
        case userId
    }
}

// MARK: - Post
protocol Post {
    var postID: String? {get}
    var videoURL: String? {get}
    var thumbnailURL: String? {get}
    var likes: Int? {get}
}

struct UserPost: Codable, Post {
    let postID: String?
    let videoURL: String?
    let thumbnailURL: String?
    let likes: Int?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case videoURL = "videoUrl"
        case thumbnailURL = "thumbnail_url"
        case likes
    }
}

struct ProfileInfo {
    let userId: String?
    let username: String?
    let profilePictureURL: String?
}

extension ProfileData {
    var info: ProfileInfo {
        ProfileInfo(userId: self.userId, username: self.username, profilePictureURL: self.profilePictureURL)
    }
}
