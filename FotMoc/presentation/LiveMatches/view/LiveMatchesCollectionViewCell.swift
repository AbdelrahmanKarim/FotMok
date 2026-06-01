//
//  LiveMatchesCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit

class LiveMatchesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellUiView: UIView!
    @IBOutlet weak var livePillarView: UIView!
    @IBOutlet weak var liveCircularView: UIView!
    
    @IBOutlet weak var liveLabel: UILabel!
    
    @IBOutlet weak var liveMinutesLabel: UILabel!
    
    @IBOutlet weak var firstTeamImage: UIImageView!
    
    @IBOutlet weak var secondTeamImage: UIImageView!
    
    @IBOutlet weak var firstTeamLabel: UILabel!
    
    @IBOutlet weak var secondTeamLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        cellUiView.backgroundColor = AppColor.accentLight
            
            contentView.layer.cornerRadius = 16
            contentView.layer.masksToBounds = true
            
            layer.cornerRadius = 16
            layer.masksToBounds = false
            

            livePillarView.backgroundColor = AppColor.error.withAlphaComponent(0.15)
            livePillarView.layer.cornerRadius = 15
            
           
            liveCircularView.backgroundColor = AppColor.error
            liveCircularView.layer.cornerRadius = 5
            
          
            liveLabel.font = AppFont.inter(weight: .bold, size: 12)
            liveLabel.textColor = AppColor.error
            
          
            liveMinutesLabel.font = AppFont.h3
            liveMinutesLabel.textColor = AppColor.textPrimary
            
           
            firstTeamLabel.font = AppFont.bodyMedium
            firstTeamLabel.textColor = AppColor.textPrimary
            
            secondTeamLabel.font = AppFont.bodyMedium
            secondTeamLabel.textColor = AppColor.textPrimary
            
           
            scoreLabel.font = AppFont.h1
            scoreLabel.textColor = AppColor.textPrimary
            scoreLabel.textAlignment = .center
            
            
            firstTeamImage.backgroundColor = AppColor.bgSurface3
            firstTeamImage.layer.cornerRadius = 25
            
            secondTeamImage.backgroundColor = AppColor.bgSurface3
            secondTeamImage.layer.cornerRadius = 25
        }
        
       
        
        func configure(firstTeam: String, secondTeam: String, score: String, minute: String) {
            firstTeamLabel.text = firstTeam
            secondTeamLabel.text = secondTeam
            scoreLabel.text = score
            liveMinutesLabel.text = minute
            
            
        }
}
