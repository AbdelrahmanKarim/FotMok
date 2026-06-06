//
//  PlayerStatBarView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 31/05/2026.
//

import UIKit

class PlayerStatBarView: UIView {

    @IBOutlet weak var statProgressView: UIProgressView!
    @IBOutlet weak var statValueLabel: UILabel!
    @IBOutlet weak var statTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        statTitleLabel.font = AppFont.bodyMedium
        statTitleLabel.textColor = AppColor.textPrimary
        
        statValueLabel.font = AppFont.bodyMedium
        statValueLabel.textColor = AppColor.textPrimary
        
        statProgressView.trackTintColor = AppColor.bgSurface3
        statProgressView.layer.cornerRadius = 3
        statProgressView.clipsToBounds = true
    }
    
    func configure(title: String, value: String, progress: Float, color: UIColor) {
        statTitleLabel.text = title
        statValueLabel.text = value
        statProgressView.progress = progress
        statProgressView.progressTintColor = color
    }
}
