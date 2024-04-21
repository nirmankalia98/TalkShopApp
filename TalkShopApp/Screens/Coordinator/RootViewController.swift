//
//  RootViewController.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import Foundation
import UIKit

final class RootCoordinator: NSObject, Coordinator, ParentCoordinator {
    
    var childCoordinators = [ChildCoordinator]()
    var navigationController: UINavigationController
    var feedViewController: FeedsViewController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool) {
    }
}
