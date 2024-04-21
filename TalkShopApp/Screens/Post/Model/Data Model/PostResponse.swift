//
//  PostResponse.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

// MARK: - PostResponse
struct PostResponse: Codable {
    let status: String?
    let data: DiscoveredPost?
}



struct DiscoveredPost: Codable, Post {
    let userID, postID: String?
    let videoURL: String?
    let thumbnailURL: String?
    let username: String?
    let likes: Int?
    let userImageURL: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case postID = "postId"
        case videoURL = "videoUrl"
        case thumbnailURL = "thumbnail_url"
        case username, likes
        case userImageURL = "userImageUrl"
    }
}

struct BaseServerResponse: Codable {
    let status: String?
    let message: String?
}

extension BaseServerResponse {
    var serverStatus: ServerStatus? {
        ServerStatus(rawValue: status ?? "")
    }
}
