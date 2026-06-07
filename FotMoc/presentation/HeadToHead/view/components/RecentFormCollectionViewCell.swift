//
//  RecentFormCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//
import UIKit
import Kingfisher
import SkeletonView

class RecentFormCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var firstTeamImage: UIImageView!
    @IBOutlet weak var secondTeamImage: UIImageView!
    @IBOutlet weak var firstTeamLabel: UILabel!
    @IBOutlet weak var secondTeamLabel: UILabel!
    @IBOutlet var teamOneBadges: [UIButton]!
    @IBOutlet var teamTwoBadges: [UIButton]!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        setupSkeleton()
    }

    private func setupCardStyle() {
        contentView.backgroundColor = AppColor.accentLight
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        firstTeamLabel.font      = AppFont.bodyMedium
        firstTeamLabel.textColor = AppColor.textPrimary
        secondTeamLabel.font      = AppFont.bodyMedium
        secondTeamLabel.textColor = AppColor.textPrimary

        firstTeamImage.layer.cornerRadius = 20
        firstTeamImage.clipsToBounds = true
        firstTeamImage.backgroundColor = AppColor.bgSurface3

        secondTeamImage.layer.cornerRadius = 20
        secondTeamImage.clipsToBounds = true
        secondTeamImage.backgroundColor = AppColor.bgSurface3

        let badgeFont = AppFont.inter(weight: .bold, size: 12)
        for button in teamOneBadges + teamTwoBadges {
            button.titleLabel?.font = badgeFont
            button.layer.cornerRadius = 6
            button.setTitleColor(.white, for: .normal)
        }
    }

    private func setupSkeleton() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        firstTeamImage.isSkeletonable = true
        secondTeamImage.isSkeletonable = true
        firstTeamLabel.isSkeletonable = true
        secondTeamLabel.isSkeletonable = true
        firstTeamImage.skeletonCornerRadius = 20
        secondTeamImage.skeletonCornerRadius = 20
       
    }

    func configure(firstTeam: TeamRecentForm, secondTeam: TeamRecentForm) {
        firstTeamLabel.text  = firstTeam.teamName
        secondTeamLabel.text = secondTeam.teamName

        firstTeamImage.kf.setImage(
            with: firstTeam.logoUrl,
            placeholder: UIImage(systemName: "shield"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )
        secondTeamImage.kf.setImage(
            with: secondTeam.logoUrl,
            placeholder: UIImage(systemName: "shield"),
            options: [.transition(.fade(0.3)), .cacheOriginalImage]
        )

        (teamOneBadges + teamTwoBadges).forEach { $0.isHidden = true }

        for (index, outcome) in firstTeam.form.enumerated() {
            guard index < teamOneBadges.count else { break }
            teamOneBadges[index].isHidden = false
            applyBadgeColor(button: teamOneBadges[index], result: outcome.rawValue)
        }

        for (index, outcome) in secondTeam.form.enumerated() {
            guard index < teamTwoBadges.count else { break }
            teamTwoBadges[index].isHidden = false
            applyBadgeColor(button: teamTwoBadges[index], result: outcome.rawValue)
        }
    }

    private func applyBadgeColor(button: UIButton, result: String) {
        button.setTitle(result, for: .normal)
        switch result.uppercased() {
        case "W": button.backgroundColor = AppColor.success
        case "D": button.backgroundColor = AppColor.warning
        case "L": button.backgroundColor = AppColor.error
        default:  button.backgroundColor = AppColor.bgSurface3
        }
    }
}
