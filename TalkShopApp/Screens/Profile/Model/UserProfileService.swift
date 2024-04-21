//
//  UserProfileService.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import Foundation

fileprivate let mockJson = """
{
    "status": "success",
    "data": {
        "username": "user123",
        "profilePictureUrl": "https://randomuser.me/api/portraits/lego/5.jpg",
        "posts": [
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            },
            {
      "postId": "post_id_1",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-large-hill-covered-with-trees-from-above-51670-large.mp4",
      "thumbnail_url": "https://picsum.photos/200/300",
      "likes": 56
            },
            {
      "postId": "post_id_2",
      "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
      "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
      "likes": 102
            }
        ]
    }
}
"""
typealias ProfileServiceClosure = ((Result<ProfileResponse>) -> Void)

protocol ProfileServiceProtocol {
    func fetchProfileData(userId: String, completion: @escaping ProfileServiceClosure  )
}

struct ProfileService: ProfileServiceProtocol {
    
    private let decoder = JSONDecoder()
    
    private func parseMockData(completion: @escaping ProfileServiceClosure) {
        let data = mockJson.data(using: .utf8)
        do {
            let resData = try decoder.decode(ProfileResponse.self, from: data!)
            completion(.success(resData))
        } catch {
            completion(.failure(error))
            debugPrint(#function, error)
        }
    }
    func fetchProfileData(userId: String, completion: @escaping ProfileServiceClosure) {
        let endpoint = UserProfileAPI.fetchProfileData(userId: userId)
        NetworkService.shared.request(endpoint, type: ProfileResponse.self) { res in
            parseMockData(completion: completion)
            return
//            switch res {
//            case .success(let profileRes):
//                completion(.success(profileRes))
//            case .failure(let error):
//                completion(.failure(error))
//            }
        }
    }
}
