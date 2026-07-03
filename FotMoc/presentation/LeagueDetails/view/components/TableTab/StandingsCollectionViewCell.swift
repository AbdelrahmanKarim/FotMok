//
//  StandingsCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 28/05/2026.
//

import UIKit
import SkeletonView
class StandingsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var playedGames: UILabel!
    
    @IBOutlet weak var winsNumber: UILabel!
    
    @IBOutlet weak var drawsNumber: UILabel!
    
    @IBOutlet weak var losesNumber: UILabel!
    
    @IBOutlet weak var goals: UILabel!
    
    @IBOutlet weak var goalsDifference: UILabel!
    
    @IBOutlet weak var points: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSkeleton()
        setupCardStyle()
       
        // Initialization code
    }
    func setupCardStyle(){
        
      
        rank.font = AppFont.caption
        rank.textColor = AppColor.textPrimary
        
        teamName.font = AppFont.small
        teamName.textColor = AppColor.textPrimary
        
        playedGames.font = AppFont.small
        playedGames.textColor = AppColor.accentPrimary
        
        winsNumber.font = AppFont.small
        winsNumber.textColor = AppColor.accentPrimary
        
        drawsNumber.font = AppFont.small
        drawsNumber.textColor = AppColor.accentPrimary
        
        losesNumber.font = AppFont.small
        losesNumber.textColor = AppColor.accentPrimary
        
        goals.font = AppFont.small
        goals.textColor = AppColor.accentPrimary
        
        goalsDifference.font = AppFont.small
        goalsDifference.textColor = AppColor.accentPrimary
        
        points.font = AppFont.small
        points.textColor = AppColor.accentPrimary
        
        
        
    }
   
 
        private func setupSkeleton() {
          
            self.isSkeletonable = true
            self.contentView.isSkeletonable = true
           
            rank.isSkeletonable = true
            teamImage.isSkeletonable = true
            teamName.isSkeletonable = true
            playedGames.isSkeletonable = true
            winsNumber.isSkeletonable = true
            drawsNumber.isSkeletonable = true
            losesNumber.isSkeletonable = true
            goals.isSkeletonable = true
            goalsDifference.isSkeletonable = true
            points.isSkeletonable = true
           
            teamImage.layer.cornerRadius = teamImage.frame.height / 2
            teamImage.clipsToBounds = true
        }
    func configure(rank: String, teamName: String, logoUrl: URL?,
                   PG: Int, W: Int, D: Int, L: Int,
                   goals: Int, GD: Int, PTS: Int) {
        self.rank.text          = rank
        self.teamName.text      = teamName
        self.playedGames.text   = "\(PG)"
        self.winsNumber.text    = "\(W)"
        self.drawsNumber.text   = "\(D)"
        self.losesNumber.text   = "\(L)"
        self.goals.text         = "\(goals)"
        self.goalsDifference.text = "\(GD)"
        self.points.text        = "\(PTS)"

        teamImage.kf.setImage(
            with: logoUrl,
            placeholder: UIImage(systemName: "shield"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }

}
