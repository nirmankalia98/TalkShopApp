//
//  UIImageView+Extension.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit

extension UIImageView {
    func setImageView(url: String) {
        ImageLoader.shared.request(url) {[weak self] resImage in
            switch resImage {
            case .success(let image):
                self?.image = image
            case .failure(let err):
                debugPrint(#function, err)
            }
        }
    }
}
