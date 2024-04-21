//
//  MasterScreenFactory.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import Foundation
import UIKit

final class MasterScreenFactory {
    private init() {}
    static let shared = MasterScreenFactory()
    let navigationController = MasterViewController()
    private var coordinator: Coordinator?
    func getCoordinator() -> Coordinator {
        guard let coordinator = coordinator else  {
            self.coordinator = FeedViewCoordinator(navigationController: navigationController)
            return coordinator!
        }
        return coordinator
    }
}


class MasterViewController: UINavigationController { }
