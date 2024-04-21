//
//  LikeAPI.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation


enum LikeAPI: Endpoint {
    case sendLike(didLike: Bool, userId: String, postId: String)

    var httpMethod: HTTPMethod { .get }
    
    var path: String { "\(baseUrl)/api/like"}
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .sendLike(let didLike, let userId, let postId):
            return [.init(name: "liked", value: "\(didLike)") ,.init(name: "userId", value: userId) , .init(name: "postId", value: postId)]
        }
    }
}
