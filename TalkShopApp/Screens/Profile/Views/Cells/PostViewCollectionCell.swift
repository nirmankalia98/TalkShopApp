//
//  PostViewCollectionCell.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit

class PostViewCollectionCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var playIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        return imageView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(with imageUrl: String) {
        imageView.setImageView(url: imageUrl)
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.addSubview(playIcon)
        imageView.pinWithPadding(to: self, padding: 0)
        playIcon.pinCenter(to: imageView)
        playIcon.setConstantDimensions(dimensions: [
            playIcon.heightAnchor : 24,
            playIcon.widthAnchor : 24
        ])
    }
}
