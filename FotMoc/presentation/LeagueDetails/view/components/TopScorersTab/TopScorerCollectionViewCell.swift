//
//  TopScorerCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 29/05/2026.
//

import UIKit
import Kingfisher
class TopScorerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentUiView: UIView!
    
    @IBOutlet weak var playerPlaceLabel: UILabel!
    
    @IBOutlet weak var circularImageView: UIView!
    
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var playerTeamLabel: UILabel!
    
    @IBOutlet weak var goalsNumber: UILabel!
    
    @IBOutlet weak var goalsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        setupSkeleton()
        // Initialization code
    }
    func setupCardStyle() {
        contentUiView.backgroundColor = AppColor.accentLight
        contentUiView.layer.cornerRadius = 20
        contentUiView.layer.masksToBounds = true

        playerPlaceLabel.font      = AppFont.h2
        playerPlaceLabel.textColor = AppColor.textTertiary

        circularImageView.layer.cornerRadius = circularImageView.frame.height / 2
        circularImageView.clipsToBounds = true
        circularImageView.backgroundColor = AppColor.bgSurface2

        playerNameLabel.font      = AppFont.h3
        playerNameLabel.textColor = AppColor.textPrimary

        playerTeamLabel.font      = AppFont.caption
        playerTeamLabel.textColor = AppColor.textSecondary

        goalsNumber.font      = AppFont.h2
        goalsNumber.textColor = AppColor.accentPrimary

        goalsLabel.font      = AppFont.caption
        goalsLabel.textColor = AppColor.textSecondary
    }
    private func setupSkeleton() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        contentUiView.isSkeletonable = true
        playerPlaceLabel.isSkeletonable = true
        playerNameLabel.isSkeletonable = true
        playerTeamLabel.isSkeletonable = true
        goalsNumber.isSkeletonable = true
        goalsLabel.isSkeletonable = true
        playerImage.isSkeletonable = true
        circularImageView.isSkeletonable = true
    }
    
    func configure(rank: Int, name: String, teamName: String, goals: Int, playerImageURL: URL?) {
        playerPlaceLabel.text = "\(rank)"
        playerNameLabel.text = name
        playerTeamLabel.text = teamName
        goalsNumber.text = "\(goals)"
        goalsLabel.text = "Goals"

        playerImage.kf.setImage(
            with: playerImageURL,
            placeholder: UIImage(systemName: "person.circle.fill"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
    }
}
