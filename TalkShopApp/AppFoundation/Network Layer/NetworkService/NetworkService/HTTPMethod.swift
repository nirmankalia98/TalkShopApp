//
//  HTTPMethod.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation
// MARK: - HTTP Method

enum HTTPMethod {
    case get
    case patch
    case post
    case put
    
    var asString: String {
        switch self {
        case .get:
            return "GET"
        case .patch:
            return "PATCH"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}
