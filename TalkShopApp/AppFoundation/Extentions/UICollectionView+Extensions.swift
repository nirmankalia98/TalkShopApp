//
//  UICollectionView+Extensions.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    func registerNib<T: UICollectionViewCell>(_: T.Type) where T: NibLoadable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: nil)
        debugPrint(T.identifier, nib, " registerNib")
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    //Registering Supplementary View
    
    func register<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) {
        register(T.self, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.identifier)
    }
    
    func registerNib<T: UICollectionReusableView>(_: T.Type, supplementaryViewOfKind: String) where T: NibLoadable {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: supplementaryViewOfKind, withReuseIdentifier: T.identifier)
    }
    
    //Dequeing
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind: String, indexPath: IndexPath) -> T  {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue supplementary view with identifier: \(T.identifier)")
        }
        return supplementaryView
    }
}
