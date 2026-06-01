//
//  UpcomingCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit

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
    func configure(homeTeam: String, awayTeam: String, date: String, time: String) {
            firstTeamLabel.text = homeTeam
            secondTeamLabel.text = awayTeam
            
            dateLabel.text = date
            timeLabel.setTitle(time, for: .normal)
            
         
        }
}
