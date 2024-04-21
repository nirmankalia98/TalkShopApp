//
//  FeedsResponse.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation

// MARK: - FeedsResponse
struct FeedsResponse: Codable {
    let status: String
    let data: [FeedData]
}

// MARK: - Feed
struct FeedData: Codable, Post {
    let userId: String?
    let postID: String?
    let videoURL: String?
    let thumbnailURL: String?
    let username: String
    let likes: Int?
    let userImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case videoURL = "videoUrl"
        case thumbnailURL = "thumbnail_url"
        case username, likes
        case userImageUrl
        case userId
    }
}
