//
//  Teams_Players_Cell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//

import UIKit

class Teams_Players_Cell: UICollectionViewCell {
   
    @IBOutlet weak var cardContainerView: UIView!
    
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var circularView: UIView!
    
    @IBOutlet weak var teamNameLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCardStyle()
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
    
    func configure(teamName: String) {
            teamNameLabel.text = teamName
         
        }
}


