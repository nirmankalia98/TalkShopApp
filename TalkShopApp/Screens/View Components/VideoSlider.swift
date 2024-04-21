//
//  SliderView.swift
//  VideoSlider
//
//  Created by Nirman Kalia on 19/04/24.
//

import Foundation

import UIKit

final class VideoSlider: UISlider {

    private let baseLayer = CALayer()
    private let trackLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        setup()
//    }

    private func setup() {
        clear()
        createBaseLayer()
        createThumbImageView()
        configureTrackLayer()
        addUserInteractions()
    }

    private func clear() {
        tintColor = .clear
        maximumTrackTintColor = .clear
        backgroundColor = .clear
        thumbTintColor = .clear
    }

    private func createBaseLayer() {
        baseLayer.borderWidth = 1
        baseLayer.borderColor = UIColor.clear.cgColor
        baseLayer.masksToBounds = true
        baseLayer.backgroundColor = UIColor.gray.cgColor
        baseLayer.frame = .init(x: 0, y: 0, width: frame.width, height: frame.height)
        layer.insertSublayer(baseLayer, at: 0)
    }

    private func configureTrackLayer() {
        let firstColor = UIColor(red: 210/255, green: 152/255, blue: 238/255, alpha: 1).cgColor
        let secondColor = UIColor(red: 166/255, green: 20/255, blue: 217/255, alpha: 1).cgColor
        trackLayer.colors = [firstColor, secondColor]
        trackLayer.startPoint = .init(x: 0, y: 0.5)
        trackLayer.endPoint = .init(x: 1, y: 0.5)
        trackLayer.frame = .init(x: 0, y: frame.height, width: 0, height: frame.height)
        layer.insertSublayer(trackLayer, at: 1)
    }

    private func addUserInteractions() {
        addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
    }

    @objc private func valueChanged(_ sender: VideoSlider) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbRectA = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        trackLayer.frame = .init(x: 0, y: 0, width: thumbRectA.midX, height: frame.height)
        CATransaction.commit()
    }

    // Step 5
    private func createThumbImageView() {
        let thumbSize = (frame.height) / 2
        let thumbView = ThumbView(frame: .init(x: 0, y: 0, width: 6, height: frame.height))
        thumbView.layer.cornerRadius = 3
        let thumbSnapshot = thumbView.snapshot
        setThumbImage(thumbSnapshot, for: .normal)
        // Step 6
        setThumbImage(thumbSnapshot, for: .highlighted)
        setThumbImage(thumbSnapshot, for: .application)
        setThumbImage(thumbSnapshot, for: .disabled)
        setThumbImage(thumbSnapshot, for: .focused)
        setThumbImage(thumbSnapshot, for: .reserved)
        setThumbImage(thumbSnapshot, for: .selected)
    }
}

// Step 4
final class ThumbView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .black
//        let middleView = UIView(frame: .init(x: frame.midX - 6, y: frame.midY - 6, width: 12, height: 12))
//        middleView.backgroundColor = .black
//        middleView.layer.cornerRadius = 6
//        addSubview(middleView)
    }
}

// Step 4
extension UIView {

    var snapshot: UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let capturedImage = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return capturedImage
    }
}
