//
//  AnimatableButton.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import UIKit

class AnimatableButton: UIButton {
    func setup() {
        self.setImage(UIImage(systemName: "play.fill"), for: .normal)
        self.tintColor = .white
        self.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.center = CGPoint(x: bounds.midX, y: bounds.midY)
        self.alpha = 0
    }
    
    func startAnimating() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.autoreverse, .repeat], animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    func stopAnimating() {
        self.layer.removeAllAnimations()
        self.alpha = 0
    }
}
