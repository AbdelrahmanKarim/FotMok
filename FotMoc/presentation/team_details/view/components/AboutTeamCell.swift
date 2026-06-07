//
//  AboutTeamCell.swift
//  FotMoc
//
//  Created by abdelrahman karim on 31/05/2026.
//
import UIKit

class AboutTeamCell: UICollectionViewCell {

    @IBOutlet weak var aboutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = AppColor.bgSurface
        contentView.layer.cornerRadius = 16
        
        aboutLabel.font = AppFont.bodyMedium
        aboutLabel.textColor = AppColor.textSecondary
        aboutLabel.numberOfLines = 0
    }
    
    func configure(text: String) {
        aboutLabel.text = text
    }
}
