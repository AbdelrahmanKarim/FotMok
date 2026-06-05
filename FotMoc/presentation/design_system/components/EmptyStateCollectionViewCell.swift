//
//  EmptyStateCollectionViewCell.swift
//  FotMoc
//
//  Created by Alaa Ayman on 05/06/2026.
//

import UIKit

class EmptyStateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var emptyStateImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupStyle()
    }
    func configure(message: String, iconName: String = "tray") {
            emptyStateLabel.text = message
            
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
            emptyStateImage.image = UIImage(systemName: iconName, withConfiguration: symbolConfig)
        }
        
        private func setupStyle() {
            
            emptyStateLabel.font = AppFont.bodyMedium
            emptyStateLabel.textColor = AppColor.textSecondary
            emptyStateLabel.textAlignment = .center
            emptyStateLabel.numberOfLines = 0
            
            emptyStateImage.tintColor = AppColor.accentPrimary
            emptyStateImage.contentMode = .scaleAspectFit
        }
}
