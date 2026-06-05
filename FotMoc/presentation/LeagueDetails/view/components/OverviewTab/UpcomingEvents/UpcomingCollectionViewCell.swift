//
//  UpcomingCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit
import Kingfisher
import SkeletonView
class UpcomingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentUiView: UIView!
    @IBOutlet weak var firstTeamImage: UIImageView!
    
    @IBOutlet weak var secondTeamImage: UIImageView!
    
    @IBOutlet weak var firstTeamLabel: UILabel!
    
    @IBOutlet weak var secondTeamLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        setupSkeleton()
        // Initialization code
    }
    private func setupCardStyle() {
         contentUiView.backgroundColor = AppColor.accentLight
          contentUiView.layer.cornerRadius = 20
          contentUiView.layer.masksToBounds = true
        
    
            
          firstTeamLabel.font = AppFont.bodyMedium
          firstTeamLabel.textColor = AppColor.textPrimary
            
          secondTeamLabel.font = AppFont.bodyMedium
          secondTeamLabel.textColor = AppColor.textPrimary
            
           
          dateLabel.font = AppFont.caption
          dateLabel.textColor = AppColor.textSecondary
            
 
          timeLabel.setTitleColor(AppColor.accentPrimary, for: .normal)
          timeLabel.titleLabel?.font = AppFont.h3
          timeLabel.backgroundColor = AppColor.bgSurface3
          timeLabel.layer.cornerRadius = 8
        }
    private func setupSkeleton() {
     
          
            self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        contentUiView.isSkeletonable = true
        contentUiView.layer.cornerRadius = 20
        contentUiView.clipsToBounds = false
        contentUiView.layer.masksToBounds = false
          
            firstTeamImage.isSkeletonable = true
            secondTeamImage.isSkeletonable = true
            firstTeamLabel.isSkeletonable = true
            secondTeamLabel.isSkeletonable = true
            dateLabel.isSkeletonable = true
            timeLabel.isSkeletonable = true
            
         
            firstTeamImage.skeletonCornerRadius = 15
            secondTeamImage.skeletonCornerRadius = 15
        }
    func configure(with match: Match) {
        firstTeamLabel.text = extractName(from: match.homeCompetitor)
        secondTeamLabel.text = extractName(from: match.awayCompetitor)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        dateLabel.text = dateFormatter.string(from: match.date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeLabel.setTitle(timeFormatter.string(from: match.date), for: .normal)
        
        
        firstTeamImage.kf.setImage(
            with: extractLogoUrl(from: match.homeCompetitor),
            placeholder: UIImage(systemName: "shield")
        )
        secondTeamImage.kf.setImage(
            with: extractLogoUrl(from: match.awayCompetitor),
            placeholder: UIImage(systemName: "shield")
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
