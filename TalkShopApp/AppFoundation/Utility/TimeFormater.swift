//
//  TimeFormater.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation

struct TimeFormater {
    static func formatTime(seconds: Float) -> String {
        guard !seconds.isInfinite, !seconds.isNaN, !seconds.isZero else { return "--:--" }
        let remainingSeconds = Int(seconds) % 60
        let remainingMinutes = (Int(seconds) / 60) % 60
        let remainingHours = (Int(seconds) / 3600)
        if remainingHours > 0 {
            return String(format: "%d:%02d:%02d", remainingHours, remainingMinutes, remainingSeconds)
        } else {
            return String(format: "%02d:%02d", remainingMinutes, remainingSeconds)
        }
    }
}
