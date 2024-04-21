//
//  NibInstanseable.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit

protocol NibLoadable: AnyObject {
    func setupView()
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        self.identifier
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    static func instanceFromNib() -> Self {
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! Self
        view.setupView()
        return view
    }
    
    func setupView() {}
}
