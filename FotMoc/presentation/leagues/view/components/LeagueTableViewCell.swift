//
//  LeagueTableViewCell.swift
//  FotMoc
//

import UIKit
import Kingfisher
import SkeletonView

class LeagueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leagueTitle: UILabel!
    
    @IBOutlet weak var leagueIcon: UIImageView!
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
        self.isSkeletonable = true
        contentView.isSkeletonable = true
        leagueTitle.isSkeletonable = true
        leagueCountry.isSkeletonable = true
        leagueIcon.isSkeletonable = true
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            let spacing: CGFloat = 12
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: spacing, right: 0))
            leagueIcon.layer.cornerRadius = leagueIcon.frame.height / 2
            leagueIcon.clipsToBounds = true
        }
 
    func configure(with league: League) {
            leagueTitle.text = league.name
            leagueCountry.text = league.country?.name ?? "Unknown"
            
     
            let placeholderImage = UIImage(named: "league_placeholder")
            
            if let url = league.logoUrl {
                leagueIcon.kf.setImage(
                    with: url,
                    placeholder: placeholderImage,
                    options: [.transition(.fade(0.3))]
                )
            } else {
                
                leagueIcon.image = placeholderImage
            }
        }
}
