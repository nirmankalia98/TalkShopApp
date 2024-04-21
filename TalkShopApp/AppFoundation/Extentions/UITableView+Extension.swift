//
//  UITableView+Extension.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 19/04/24.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) where T: NibLoadable  {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        self.register(nib, forCellReuseIdentifier: T.nibName)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Error dequeueing cell for identifier \(T.identifier)")
        }
        return cell
    }
}
