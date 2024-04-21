//
//  PostAPI.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation


enum PostAPI: Endpoint {
    
    case fetchPostData(postId: String)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchPostData:
                .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
        switch self {
        case .fetchPostData(let postId):
            return [.init(name: "postId", value: postId)]
        }
    }
    
    var path: String {
        switch self {
        case .fetchPostData:
            "/b/5BNS"
        }
    }
}
