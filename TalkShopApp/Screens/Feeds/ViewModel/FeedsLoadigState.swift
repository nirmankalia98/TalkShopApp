//
//  FeedsLoadigState.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation

enum FeedsLoadingState {
    case loading
    case empty
    case success
    case failed
    case reloading
    case loadingMore
}
