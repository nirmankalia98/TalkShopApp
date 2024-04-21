//
//  PageInfo.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

struct PageInfo {
    
    init(currentPage: Int = 0, pageSize: Int = 2) {
        self.currentPage = currentPage
        self.pageSize = pageSize
    }
    private var lastPage = 4 // mocking it to show pagination works properly
    let pageSize: Int
    var currentPage: Int? = 0
    var isLastPage: Bool {
        currentPage == nil
    }
    var isFetchingPage = false
    
    mutating func nextPageToFetch() -> Int? {
        guard let currentPage = currentPage else { return nil }
        self.isFetchingPage = true
        if currentPage == lastPage {
            self.currentPage = nil
            return nil
        } // mockig the end of pagination
        return currentPage + 1
    }
    
    mutating func didFinishPagination(count: Int) {
        guard let currentPage = currentPage else { return }
        self.currentPage = count < self.pageSize ? nil : currentPage + 1
        self.isFetchingPage = false
    }
}
