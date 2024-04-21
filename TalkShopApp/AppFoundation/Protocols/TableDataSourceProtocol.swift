//
//  TableDataSourceProtocol.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation


protocol TableViewDataSource {
    var tableDelegate: AnyObject? { get }
    func numberOfRows(for section: Int) -> Int
    func numberOfSections() -> Int
}

extension TableViewDataSource {
    func numberOfSections() -> Int { return 1 }
}
