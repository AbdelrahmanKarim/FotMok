//
//  CustomSectionHeader.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//

import UIKit

class CustomSectionHeader: UICollectionReusableView {

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCustomHeaderStyle()
        // Initialization code
    }
    func setupCustomHeaderStyle(){
        headerTitle.font = AppFont.caption
        headerTitle.textColor = AppColor.textPrimary
        headerImage.tintColor = AppColor.accentPrimary
    }
    func configure(title: String, iconName: String) {
            headerTitle.text = title
            headerImage.image = UIImage(systemName: iconName)
        }
}
