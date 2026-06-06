//
//  statsGridCollectionViewCell.swift
//  FotMoc
//
//  Created by abdelrahman karim on 30/05/2026.
//

import UIKit

class statsGridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var statTitleLabel: UILabel!
    @IBOutlet weak var statValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = AppColor.bgSurface
        contentView.layer.cornerRadius = 12
        
        statTitleLabel.font = AppFont.caption
        statTitleLabel.textColor = AppColor.textSecondary
        
        statValueLabel.font = AppFont.h2
        statValueLabel.textColor = AppColor.textPrimary
    }

    func configure(title: String, value: String, valueColor: UIColor = AppColor.textPrimary) {
        statTitleLabel.text = title
        statValueLabel.text = value
        statValueLabel.textColor = valueColor
    }
}
