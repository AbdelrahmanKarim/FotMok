//
//  Teams_Players_Cell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//

import UIKit
import SkeletonView
class Teams_Players_Cell: UICollectionViewCell {
   
    @IBOutlet weak var cardContainerView: UIView!
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var circularView: UIView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCardStyle()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        applyColors()
    }

    
    private func applyColors() {
        cardContainerView.backgroundColor = AppColor.accentLight
        circularView.backgroundColor      = AppColor.bgSurface3
        teamNameLabel.textColor           = AppColor.textPrimary
    }
    private func setupCardStyle() {
        cardContainerView.backgroundColor = AppColor.accentLight
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.layer.masksToBounds = true
        
        circularView.backgroundColor = AppColor.bgSurface3
        circularView.layer.cornerRadius = circularView.frame.height / 2
       
        circularView.clipsToBounds = true
        teamNameLabel.font = AppFont.bodyMedium
        teamNameLabel.textColor = AppColor.textPrimary
       
    }
    private func setupSkeleton() {
        
            self.isSkeletonable = true
            self.contentView.isSkeletonable = true
        cardContainerView.isSkeletonable = true
        cardContainerView.layer.cornerRadius = 20
        cardContainerView.clipsToBounds = false
        cardContainerView.layer.masksToBounds = false
      
        circularView.isSkeletonable = true
        teamNameLabel.isSkeletonable = true
        teamImage.isSkeletonable = true
            
        }
    func configure(with item: Any) {
        if let team = item as? Team {
            teamNameLabel.text = team.name
            teamImage.kf.setImage(
                with: team.logoUrl,
                placeholder: UIImage(named: "league_placeholder"),
                options: [.transition(.fade(0.3))]
            )
        } else if let player = item as? Player {
            teamNameLabel.text = player.name
            teamImage.kf.setImage(
                with: player.imageUrl,
                placeholder: UIImage(named: "player_placeholder"),
                options: [.transition(.fade(0.3))]
            )
        }
    }
}


