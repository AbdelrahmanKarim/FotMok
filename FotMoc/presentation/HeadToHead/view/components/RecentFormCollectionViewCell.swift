//
//  RecentFormCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit

class RecentFormCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var firstTeamImage: UIImageView!
    
    @IBOutlet weak var secondTeamImage: UIImageView!
    
    @IBOutlet weak var firstTeamLabel: UILabel!
    
    @IBOutlet weak var secondTeamLabel: UILabel!
    
    
    @IBOutlet var teamOneBadges: [UIButton]!
    @IBOutlet var teamTwoBadges: [UIButton]!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCardStyle()
    }
    private func setupCardStyle() {
            
            contentView.backgroundColor = AppColor.accentLight
            contentView.layer.cornerRadius = 16
            contentView.layer.masksToBounds = true
            
          
            firstTeamLabel.font = AppFont.bodyMedium
            firstTeamLabel.textColor = AppColor.textPrimary
            
            secondTeamLabel.font = AppFont.bodyMedium
            secondTeamLabel.textColor = AppColor.textPrimary
            
            
            let badgeFont = AppFont.inter(weight: .bold, size: 12)
            
            for button in teamOneBadges {
                button.titleLabel?.font = badgeFont
                button.layer.cornerRadius = 6
                button.setTitleColor(AppColor.accentLight, for: .normal)
            }
            
            for button in teamTwoBadges {
                button.titleLabel?.font = badgeFont
                button.layer.cornerRadius = 6
                button.setTitleColor(AppColor.accentLight, for: .normal)
            }
        }
        
        
        func configure(firstTeam: String, secondTeam: String, teamOneResults: [String], teamTwoResults: [String]) {
            firstTeamLabel.text = firstTeam
            secondTeamLabel.text = secondTeam
            
          
            for (index, result) in teamOneResults.enumerated() {
                if index < teamOneBadges.count {
                    let badge = teamOneBadges[index]
                    badge.isHidden = false
                    applyBadgeColor(button: badge, result: result)
                }
            }
            
        
            for (index, result) in teamTwoResults.enumerated() {
                if index < teamTwoBadges.count {
                    let badge = teamTwoBadges[index]
                    badge.isHidden = false
                    applyBadgeColor(button: badge, result: result)
                }
            }
        }
        

        private func applyBadgeColor(button: UIButton, result: String) {
            button.setTitle(result, for: .normal)
            
            switch result.uppercased() {
            case "W":
                button.backgroundColor = AppColor.success
            case "D":
                button.backgroundColor = AppColor.warning
            case "L":
                button.backgroundColor = AppColor.error
            default:
                button.backgroundColor = AppColor.bgSurface3
            }
        }
}
