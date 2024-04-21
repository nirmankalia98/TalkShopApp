//
//  LikeButton.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 19/04/24.
//

import Foundation
import UIKit


@IBDesignable class ToggleButton: UIButton {
    
    @IBInspectable var shouldAnimate: Bool = false
    @IBInspectable var toggleImage: UIImage? = UIImage(systemName: "heart.fill")
    @IBInspectable var untoggleImage: UIImage? = UIImage(systemName: "heart")
    @IBInspectable var toggleText: String? = ""
    @IBInspectable var untoggleTet: String? = ""

    var stateChanged: ((Bool) -> Void)?

    var isToggled: Bool = false {
        didSet {
            updateButtonUI()
            if shouldAnimate {
                animateButton()
            }
            stateChanged?(isToggled)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.configuration?.imagePadding = 24
        self.addTarget(self, action: #selector(toggleButton), for: .touchUpInside)
    }

    private func updateButtonUI() {
        let image = isToggled ? toggleImage : untoggleImage
        let text = isToggled ? toggleText : untoggleTet

        self.setImage(image, for: .normal)
        self.setTitle(text, for: .normal)
        self.setTitleColor(.black, for: .normal)
    }

    @objc private func toggleButton() {
        isToggled.toggle()
    }

    private func animateButton() {
        if isToggled {
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
}
