//
//  Result.swift
//  SwiftNetworkLayer
//
//  Created by Nirman Kalia on 18/04/24.

import Foundation

// MARK: - Result

/** Generic enum used for either the success or failure of an operation */

enum Result<T> {
  case success(T)
  case failure(Error)
}

// MARK: - Result Callback

typealias ResultCallback<T> = (Result<T>) -> Void
