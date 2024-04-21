//
//  UserProfileAPI.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation


enum UserProfileAPI: Endpoint {
    
    case fetchProfileData(userId: String)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchProfileData:
             .get
        }
    }
    
    var baseUrl: String {
        "https://www.jsonkeeper.com"
    }
    
    var queryItems: [URLQueryItem]? {
        // in order to fake the response sendingn nil
        return nil
        switch self {
        case .fetchProfileData(let userId):
            return [
                .init(name: "userId", value: userId)
            ]
        }
    }
    
    var path: String {
        switch self {
        case .fetchProfileData:
             return "/b/PGP8"//"\(baseUrl)/api/feed"
        }
    }
}
