//
//  LeagueTableViewCell.swift
//  FotMoc
//
//  Created by abdelrahman karim on 20/05/2026.
//


import UIKit

class LeagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueTitle: UILabel!
    @IBOutlet weak var leagueIcon: UIView!
    @IBOutlet weak var leagueCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = AppColor.bgSurface
        contentView.layer.cornerRadius = 16
        leagueTitle.font = AppFont.bodyMedium
        leagueTitle.textColor = AppColor.textPrimary
        leagueCountry.font = AppFont.small
        leagueCountry.textColor = AppColor.textSecondary
        leagueIcon.backgroundColor = AppColor.bgSurface3
        leagueIcon.layer.cornerRadius = 8
    }
}
