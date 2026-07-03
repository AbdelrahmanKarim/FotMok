//
//  LatestEventCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 22/05/2026.
//

import UIKit
import Kingfisher
import SkeletonView
class LatestEventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentUiView: UIView!
    @IBOutlet weak var firstTeamImage: UIImageView!
    
    @IBOutlet weak var secondTeamImage: UIImageView!
    
    @IBOutlet weak var firstTeamLabel: UILabel!
    
    @IBOutlet weak var secondTeamLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var firstTagLabelBtn: UIButton!
    
    @IBOutlet weak var secondTagLabelBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        setupSkeleton()
        // Initialization code
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        applyColors()
    }
    private func applyColors() {
        contentUiView.backgroundColor = AppColor.accentLight
        firstTeamLabel.textColor  = AppColor.textPrimary
        secondTeamLabel.textColor = AppColor.textPrimary
       
        firstTagLabelBtn.backgroundColor  = AppColor.bgSurface3
        secondTagLabelBtn.backgroundColor = AppColor.bgSurface3
        
    }
    private func setupCardStyle() {
        contentUiView.backgroundColor = AppColor.accentLight
        contentUiView.layer.cornerRadius = 20
        contentUiView.layer.masksToBounds = true
    
          
       
        firstTeamLabel.font = AppFont.bodyMedium
        firstTeamLabel.textColor = AppColor.textPrimary
          
        secondTeamLabel.font = AppFont.bodyMedium
        secondTeamLabel.textColor = AppColor.textPrimary
    

       
        firstTagLabelBtn.setTitleColor(AppColor.accentPrimary, for: .normal)
        firstTagLabelBtn.titleLabel?.font = AppFont.h3
        firstTagLabelBtn.backgroundColor = AppColor.bgSurface3
        firstTagLabelBtn.layer.cornerRadius = 8
        
        
        secondTagLabelBtn.setTitleColor(AppColor.accentPrimary, for: .normal)
        secondTagLabelBtn.titleLabel?.font = AppFont.h3
        secondTagLabelBtn.backgroundColor = AppColor.bgSurface3
        secondTagLabelBtn.layer.cornerRadius = 8
        
    }
    private func setupSkeleton() {
        
            self.isSkeletonable = true
            self.contentView.isSkeletonable = true
         
            contentUiView.layer.cornerRadius = 20
            contentUiView.clipsToBounds = false
            contentUiView.layer.masksToBounds = false
      
            firstTeamImage.isSkeletonable = true
            secondTeamImage.isSkeletonable = true
            firstTeamLabel.isSkeletonable = true
            secondTeamLabel.isSkeletonable = true
            scoreLabel.isSkeletonable = true
            firstTagLabelBtn.isSkeletonable = true
            secondTagLabelBtn.isSkeletonable = true
        }
    func configure(with match: Match) {
            firstTeamLabel.text = extractName(from: match.homeCompetitor)
            secondTeamLabel.text = extractName(from: match.awayCompetitor)
            scoreLabel.text = match.score ?? "N/A"
     
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        firstTagLabelBtn.setTitle(dateFormatter.string(from: match.date), for: .normal)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        secondTagLabelBtn.setTitle(timeFormatter.string(from: match.date), for: .normal)
        
     
        firstTeamImage.kf.setImage(
            with: extractLogoUrl(from: match.homeCompetitor),
            placeholder: UIImage(named: "league_placeholder"),
            options: [.transition(.fade(0.3))]
        )
        secondTeamImage.kf.setImage(
            with: extractLogoUrl(from: match.awayCompetitor),
            placeholder: UIImage(named: "league_placeholder"),
            options: [.transition(.fade(0.3))]
        )
    }

    private func extractLogoUrl(from competitor: Competitor) -> URL? {
        switch competitor {
        case .team(let team): return team.logoUrl
        case .player(let player): return player.imageUrl  
        }
    }
    private func extractName(from competitor: Competitor) -> String {
            switch competitor {
            case .team(let team): return team.name
            case .player(let player): return player.name
            }
        }
}
