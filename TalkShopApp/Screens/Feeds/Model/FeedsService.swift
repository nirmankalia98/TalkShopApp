//
//  FeedsService.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation



enum FeedsAPI: Endpoint {
    
    case fetchFeed(userId: String, page: Int, pageSize: Int)
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchFeed:
             .get
        }
    }
    
    var queryItems: [URLQueryItem]? {
        // in order to fake the response sendingn nil
        switch self {
        case .fetchFeed(let userId, let page, let pageSize):
            return [
                .init(name: "userId", value: userId),
                .init(name: "page", value: "\(page)"),
                .init(name: "pageSize", value: "\(pageSize)")
            ]
        }
    }
    
    var path: String {
        switch self {
        case .fetchFeed:
             return "/b/5BNS"//"/api/feed"
        }
    }
}

enum DescribableError: Error {
    var message: String {
        "some error"
    }
}

typealias FeedsClosure = ((Result<[FeedData]>) -> Void)

protocol FeedsServiceProtocol: LikeServiceProtocol {
    func fetchFeeds(for userId: String, page: Int, pageSize: Int, completion: @escaping FeedsClosure)
}

fileprivate let mockJson = """
    {
        "status": "success",
        "data": [
            {
                "postId": "post_id_1",
                "videoUrl": "https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_20mb.mp4",
                "thumbnail_url": "https://upload.wikimedia.org/wikipedia/commons/a/a7/Big_Buck_Bunny_thumbnail_vlc.png",
                "username": "user123",
                "likes": 56,
                "userImageUrl": "https://randomuser.me/api/portraits/lego/5.jpg"
            },
            {
                "postId": "post_id_2",
                "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-people-pouring-a-warm-drink-around-a-campfire-513-large.mp4",
                "thumbnail_url": "https://picsum.photos/200/300",
                "username": "user456",
                "likes": 102,
                "userImageUrl": "https://randomuser.me/api/portraits/lego/7.jpg"
            },
            {
                "postId": "post_id_2",
                "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-stars-in-space-background-1610-small.mp4",
                "thumbnail_url": "https://picsum.photos/200/300",
                "username": "user456",
                "likes": 102,
                "userImageUrl": "https://randomuser.me/api/portraits/lego/2.jpg"
            },
            {
                "postId": "post_id_2",
                "videoUrl": "https://assets.mixkit.co/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-large.mp4",
                "thumbnail_url": "https://mixkit.imgix.net/videos/preview/mixkit-very-close-shot-of-the-leaves-of-a-tree-wet-18310-1.jpg",
                "username": "user456",
                "likes": 102,
                "userImageUrl": "https://randomuser.me/api/portraits/lego/1.jpg"
            }
        ]
    }
    """


struct FeedsService: FeedsServiceProtocol {
    
    func fetchFeeds(for userId: String, page: Int, pageSize: Int, completion: @escaping FeedsClosure) {
        let endpoint = FeedsAPI.fetchFeed(userId: userId, page: page, pageSize: pageSize)
        NetworkService.shared.request(endpoint, type: FeedsResponse.self) { res in
            parseMockData(completion: completion)
            // mocking the data to fetch data
            return
            
//            switch res {
//            case .success(let feedsData):
//                completion(.success(feedsData.data))
//            case .failure(let err):
//                completion(.failure(err))
//            }
            
        }
    }
    
    private let decoder = JSONDecoder()
    
    private func parseMockData(completion: @escaping FeedsClosure) {
        let data = mockJson.data(using: .utf8)
        do {
            let feedsData = try decoder.decode(FeedsResponse.self, from: data!)
            completion(.success(feedsData.data))
        } catch {
            completion(.failure(error))
            debugPrint(#function, error)
        }
    }
}
