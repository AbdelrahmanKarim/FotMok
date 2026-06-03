//
//  OverallH2HCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit

class OverallH2HCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var homeWinsValue: UILabel!
    
    @IBOutlet weak var drawsValue: UILabel!
    
    @IBOutlet weak var awayWinsValue: UILabel!
    
    @IBOutlet weak var homeWinsLabel: UILabel!
    
    @IBOutlet weak var drawsLabel: UILabel!
    
    @IBOutlet weak var awayWinsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
           
            contentView.backgroundColor = AppColor.accentLight
            contentView.layer.cornerRadius = 16
            contentView.layer.masksToBounds = true
            
    
            homeWinsValue.font = AppFont.bigCaption
            homeWinsValue.textColor = AppColor.textPrimary
            
            drawsValue.font = AppFont.bigCaption
            drawsValue.textColor = AppColor.warning
            
            awayWinsValue.font = AppFont.bigCaption
            awayWinsValue.textColor = AppColor.textPrimary
            
           
            let subtitleFont = AppFont.caption
            let subtitleColor = AppColor.textSecondary
            
            homeWinsLabel.font = subtitleFont
            homeWinsLabel.textColor = subtitleColor
            
            drawsLabel.font = subtitleFont
            drawsLabel.textColor = subtitleColor
            
            awayWinsLabel.font = subtitleFont
            awayWinsLabel.textColor = subtitleColor
            
           
        }
    func configure(homeWins: String, draws: String, awayWins: String) {
            homeWinsValue.text = homeWins
            drawsValue.text = draws
            awayWinsValue.text = awayWins
        }
}
