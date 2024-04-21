//
//  Debouncer.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

class Debouncer {
    private var workItem: DispatchWorkItem?
    private let interval: TimeInterval

    init(interval: TimeInterval) {
        self.interval = interval
    }

    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()

        let task = DispatchWorkItem { action() }
        workItem = task

        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: task)
    }
}
