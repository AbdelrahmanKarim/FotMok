//
//  CustomHomeCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 20/05/2026.
//

import UIKit


class CustomHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportTitle: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCardStyle()
    }

   
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        updateShadowColor()
    }

    private func setupCardStyle() {
        contentView.layer.cornerRadius  = 20
        contentView.layer.masksToBounds = true
        contentView.backgroundColor     = AppColor.accentLight

        layer.cornerRadius  = 20
        layer.masksToBounds = false
        layer.shadowOpacity = 0.08
        layer.shadowOffset  = CGSize(width: 0, height: 4)
        layer.shadowRadius  = 12
        layer.shadowPath    = UIBezierPath(
            roundedRect: bounds, cornerRadius: 12
        ).cgPath

        sportTitle.font = AppFont.inter(weight: .bold, size: 18)
        updateShadowColor()
    }

    private func updateShadowColor() {
        layer.shadowColor = AppColor.accentPrimary.cgColor
    }
}
