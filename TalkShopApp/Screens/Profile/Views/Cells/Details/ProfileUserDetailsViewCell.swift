//
//  ProfileUserDetailsViewCell.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit

class ProfileUserDetailsViewCell: UICollectionViewCell, NibLoadable {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.clipsToBounds = true
    }
    
    func configure(with userName: String, imageURL: String, badge: String, postCount: Int) {
        nameLabel.text = userName
        accountTypeLabel.text = badge
        avatarImageView.setImageView(url: imageURL)
        numberOfPostsLabel.text = "\(postCount) posts"
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
}
