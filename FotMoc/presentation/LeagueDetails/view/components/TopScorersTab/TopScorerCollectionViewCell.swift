//
//  TopScorerCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 29/05/2026.
//

import UIKit

class TopScorerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentUiView: UIView!
    
    @IBOutlet weak var playerPlaceLabel: UILabel!
    
    @IBOutlet weak var circularImageView: UIView!
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerTeamLabel: UILabel!
    
    @IBOutlet weak var goalsNumber: UILabel!
    
    @IBOutlet weak var goalsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        // Initialization code
    }
    func setupCardStyle(){
        contentUiView.backgroundColor = AppColor.accentLight
        contentUiView.layer.cornerRadius = 20
        contentUiView.layer.masksToBounds = true
      
        playerPlaceLabel.font = AppFont.h2
        playerPlaceLabel.textColor = AppColor.textPrimary
        
        circularImageView.layer.cornerRadius = circularImageView.frame.height / 2
        circularImageView.clipsToBounds = true
        
        playerNameLabel.font = AppFont.h3
        playerNameLabel.textColor = AppColor.textPrimary
        
        playerTeamLabel.font = AppFont.caption
        playerTeamLabel.textColor = AppColor.textSecondary
        
        goalsNumber.font = AppFont.h2
        goalsNumber.textColor = AppColor.accentPrimary
        
        goalsLabel.font = AppFont.caption
        goalsLabel.textColor = AppColor.textSecondary
        
        
    }
}
