//
//  LatestEventCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 22/05/2026.
//

import UIKit

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
    

       
        firstTagLabelBtn.setTitleColor(AppColor.accentPrimary, for: .normal)
        firstTagLabelBtn.titleLabel?.font = AppFont.h3
        firstTagLabelBtn.backgroundColor = AppColor.bgSurface3
        firstTagLabelBtn.layer.cornerRadius = 8
        
        
        secondTagLabelBtn.setTitleColor(AppColor.accentPrimary, for: .normal)
        secondTagLabelBtn.titleLabel?.font = AppFont.h3
        secondTagLabelBtn.backgroundColor = AppColor.bgSurface3
        secondTagLabelBtn.layer.cornerRadius = 8
        
    }
}
