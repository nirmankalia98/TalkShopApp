//
//  Collection+Extension.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
