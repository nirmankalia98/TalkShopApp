//
//  LikeService.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

typealias BoolClosure = ((Result<Bool?>) -> Void)

protocol LikeServiceProtocol {
    func sendLikeRequest(didLike: Bool, by userId: String, for postId: String, completion: @escaping BoolClosure)
}

extension LikeServiceProtocol {
    func sendLikeRequest(didLike: Bool, by userId: String, for postId: String, completion: @escaping BoolClosure) {
        let endpoint = LikeAPI.sendLike(didLike: didLike, userId: userId, postId: postId)
        NetworkService.shared.request(endpoint, type: BaseServerResponse.self) { res in
            switch res {
            case .success(let baseResponse):
                let isSuccess = baseResponse.serverStatus == .success
                completion(.success(isSuccess))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
