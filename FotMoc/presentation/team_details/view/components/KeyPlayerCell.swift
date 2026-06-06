//
//  KeyPlayerCell.swift
//  FotMoc
//
//  Created by abdelrahman karim on 31/05/2026.
//

import UIKit
import Kingfisher

class KeyPlayerCell: UICollectionViewCell {

    @IBOutlet weak var playerRoleLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = AppColor.bgSurface
        contentView.layer.cornerRadius = 12
        
        playerNameLabel.font = AppFont.bodyMedium
        playerNameLabel.textColor = AppColor.textPrimary
        
        playerRoleLabel.font = AppFont.caption
        playerRoleLabel.textColor = AppColor.textSecondary
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerImageView.layer.cornerRadius = playerImageView.frame.height / 2
        playerImageView.clipsToBounds = true
    }
    
    func configure(player: Player) {
        playerNameLabel.text = player.name
        
        if let url = player.imageUrl {
            playerImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal))
        } else {
            playerImageView.image = UIImage(systemName: "person.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        }
        
        switch player.sportDetails {
        case .teamSport(_, let position):
            playerRoleLabel.text = position
        case .tennis(let rank, _):
            playerRoleLabel.text = rank != nil ? "Rank \(rank!)" : "Player"
        }
    }
}
