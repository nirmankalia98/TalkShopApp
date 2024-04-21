//
//  FeedsViewModel.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation

// Assuming User Details has been injected to required views
final class AppState {
    private init() {}
    static let shared = AppState()
    let currentUser = ProfileInfo(userId: "12345", username: "Mr. Robot", profilePictureURL: "https://i.kym-cdn.com/entries/icons/original/000/026/152/gigachadd.jpg")
}

protocol FeedsViewModelDelegate: AnyObject {
    func reloadData()
    func showAlert(title: String, msg: String)
    func setPaginationSate(hide: Bool)
}

final class FeedsViewModel {
    
    // MARK: Public Properties
    var feeds: [FeedData] = []
    private(set) var profileInfo = AppState.shared.currentUser
    private var service: FeedsServiceProtocol

    private var pageInfo = PageInfo()
    
    weak var viewDelegate: FeedsViewModelDelegate?
    
    required init(service: FeedsServiceProtocol) {
        self.service = service
    }
    
    
    @discardableResult func fetchData() -> Bool {
        guard let userId = profileInfo.userId else {
            self.viewDelegate?.showAlert(title: "Error", msg: "User has Invalid Id")
            return false
        }
        guard pageInfo.isFetchingPage == false, let nextPage = pageInfo.nextPageToFetch() else {
            debugPrint("cannot fetch more feeds")
            return false
        }
        self.service.fetchFeeds(for: userId, page: nextPage, pageSize: pageInfo.pageSize) {[weak self] result in
            switch result {
            case .success(let feeds):
                self?.feeds.append(contentsOf: feeds)
                self?.pageInfo.didFinishPagination(count: feeds.count)
                self?.viewDelegate?.reloadData()
            case .failure(let err):
                self?.viewDelegate?.showAlert(title: "Error", msg: "Failed to Fetch Data")
                debugPrint(err)
            }
        }
        return true
    }
    
    func checkToFetchMore(indexPath: IndexPath) {
        if indexPath.row == self.feeds.count - 1 {
            if self.fetchMoreData() {
                self.viewDelegate?.setPaginationSate(hide: false)
            }
        }
    }
    
    private func fetchMoreData() -> Bool {
        fetchData()
    }
    
    func refetchData() {
        self.pageInfo = PageInfo()
        self.feeds.removeAll()
        fetchData()
    }
    
    func sendLike(didLike: Bool, index: IndexPath) {
        guard let data = self.getData(for: index) else {
            debugPrint("User like invalid post")
            return
        }
        guard let userId = profileInfo.userId, let postID = data.postID else {
            debugPrint("User like invalid userId or postId")
            return
        }
        self.service.sendLikeRequest(didLike: didLike, by: userId, for: postID) { res in
            switch res {
            case .success(let bool):
                debugPrint("like request success \(bool)")
            case .failure(let error):
                debugPrint("like request failure \(error)")
            }
        }
    }
    
    func numberOfRows(for section: Int) -> Int {
        return feeds.count
    }
    
    func numberOfSections() -> Int { 1 }
    
    func getData(for index: IndexPath) -> FeedData? {
        self.feeds[safe: index.row]
    }
}
