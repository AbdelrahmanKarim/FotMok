//
//  StandingsHeaderCollectionReusableView.swift
//  FotMoc
//
//  Created by Alaa Ayman on 28/05/2026.
//

import UIKit

class StandingsHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var rankLabel: UILabel!
    
    @IBOutlet weak var playedGamesLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var drawsLabel: UILabel!
    @IBOutlet weak var losesLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    
    @IBOutlet weak var goalsDifferenceLabel: UILabel!
    
    @IBOutlet weak var pointsLabel: UILabel!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        // Initialization code
    }
    func setupCardStyle(){
        
      
        rankLabel.font = AppFont.caption
        rankLabel.textColor = AppColor.textPrimary
        
        playedGamesLabel.font = AppFont.small
        playedGamesLabel.textColor = AppColor.textPrimary
        
        winsLabel.font = AppFont.small
        winsLabel.textColor = AppColor.textPrimary
        
        drawsLabel.font = AppFont.small
        drawsLabel.textColor = AppColor.textPrimary
        
        losesLabel.font = AppFont.small
        losesLabel.textColor = AppColor.textPrimary
        
        goalsLabel.font = AppFont.small
        goalsLabel.textColor = AppColor.textPrimary
        
        goalsDifferenceLabel.font = AppFont.small
        goalsDifferenceLabel.textColor = AppColor.textPrimary
        
        pointsLabel.font = AppFont.small
        pointsLabel.textColor = AppColor.textPrimary
        
        
        
       
        
        
    }
}
