//
//  PostService.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

fileprivate let mockJSON = """
        {
            "status": "success",
            "data": {
                "userId": "1234",
                "postId": "post_id_1",
                "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
                "thumbnail_url": "https://picsum.photos/200/300",
                "username": "user123",
                "likes": 56,
                "userImageUrl": "https://randomuser.me/api/portraits/lego/5.jpg"
            }
        }
"""
protocol PostViewServiceProtocol: LikeServiceProtocol {
    func fetchPostData(by postId: String, completion: @escaping PostClosure)
}

typealias PostClosure = ((Result<PostResponse>) -> Void)

struct PostViewService: PostViewServiceProtocol {
    
    private let decoder = JSONDecoder()
    
    private func parseMockData(completion: @escaping PostClosure) {
        let data = mockJSON.data(using: .utf8)
        do {
            let res = try decoder.decode(PostResponse.self, from: data!)
            completion(.success(res))
        } catch {
            debugPrint("failed data")
            completion(.failure(error as! DecodingError))
            debugPrint(#function, error)
        }
    }
    
    func fetchPostData(by postId: String, completion: @escaping PostClosure  ) {
        let endpoint = PostAPI.fetchPostData(postId: postId)
        NetworkService.shared.request(endpoint, type: PostResponse.self) { res in
            self.parseMockData(completion: completion)
            return
//            switch res {
//            case .success(let postResponse):
//                completion(.success(postResponse))
//            case .failure(let err):
//                completion(.failure(err))
//            }
        }
    }
}

