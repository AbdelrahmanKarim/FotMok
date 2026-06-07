//
//  LiveMatchesCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit
import Kingfisher
import SkeletonView

class LiveMatchesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellUiView: UIView!
    @IBOutlet weak var livePillarView: UIView!
    @IBOutlet weak var liveCircularView: UIView!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var liveMinutesLabel: UILabel!
    @IBOutlet weak var firstTeamImage: UIImageView!
    @IBOutlet weak var secondTeamImage: UIImageView!
    @IBOutlet weak var firstTeamLabel: UILabel!
    @IBOutlet weak var secondTeamLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupSkeleton()
    }

    private func setupUI() {
        cellUiView.backgroundColor = AppColor.accentLight
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.masksToBounds = false

        livePillarView.backgroundColor = AppColor.error.withAlphaComponent(0.15)
        livePillarView.layer.cornerRadius = 15

        liveCircularView.backgroundColor = AppColor.error
        liveCircularView.layer.cornerRadius = 5

        liveLabel.font = AppFont.inter(weight: .bold, size: 12)
        liveLabel.textColor = AppColor.error
        liveLabel.text = NSLocalizedString("live_label", comment: "")

        liveMinutesLabel.font = AppFont.h3
        liveMinutesLabel.textColor = AppColor.textPrimary

        firstTeamLabel.font = AppFont.bodyMedium
        firstTeamLabel.textColor = AppColor.textPrimary

        secondTeamLabel.font = AppFont.bodyMedium
        secondTeamLabel.textColor = AppColor.textPrimary

        scoreLabel.font = AppFont.h3
        scoreLabel.textColor = AppColor.textPrimary
        scoreLabel.textAlignment = .center

        firstTeamImage.backgroundColor = AppColor.bgSurface3
        firstTeamImage.layer.cornerRadius = 25
        firstTeamImage.clipsToBounds = true

        secondTeamImage.backgroundColor = AppColor.bgSurface3
        secondTeamImage.layer.cornerRadius = 25
        secondTeamImage.clipsToBounds = true
    }

    private func setupSkeleton() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        cellUiView.isSkeletonable = true
        firstTeamImage.isSkeletonable = true
        secondTeamImage.isSkeletonable = true
        firstTeamLabel.isSkeletonable = true
        secondTeamLabel.isSkeletonable = true
        scoreLabel.isSkeletonable = true
        liveMinutesLabel.isSkeletonable = true
        firstTeamImage.skeletonCornerRadius = 25
        secondTeamImage.skeletonCornerRadius = 25
    }

    // Configure with real Match data
    func configure(with match: Match) {
        firstTeamLabel.text  = extractName(from: match.homeCompetitor)
        secondTeamLabel.text = extractName(from: match.awayCompetitor)
        scoreLabel.text      = match.score ?? NSLocalizedString("score_na", comment: "")

        firstTeamImage.kf.setImage(
            with: extractLogo(from: match.homeCompetitor),
            placeholder: UIImage(systemName: "shield")
        )
        secondTeamImage.kf.setImage(
            with: extractLogo(from: match.awayCompetitor),
            placeholder: UIImage(systemName: "shield")
        )

        // Extract live minute from sportDetails
        if case .football(let minute, _) = match.sportDetails {
            liveMinutesLabel.text = minute ?? ""
        }
    }

    // Keep old configure for any mock usage
    func configure(firstTeam: String, secondTeam: String, score: String, minute: String) {
        firstTeamLabel.text    = firstTeam
        secondTeamLabel.text   = secondTeam
        scoreLabel.text        = score
        liveMinutesLabel.text  = minute
    }

    private func extractName(from competitor: Competitor) -> String {
        switch competitor {
        case .team(let team):     return team.name
        case .player(let player): return player.name
        }
    }

    private func extractLogo(from competitor: Competitor) -> URL? {
        switch competitor {
        case .team(let team):     return team.logoUrl
        case .player(let player): return player.imageUrl
        }
    }
}
