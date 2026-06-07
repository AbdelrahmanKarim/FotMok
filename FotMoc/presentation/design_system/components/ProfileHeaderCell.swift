import UIKit
import Kingfisher

class ProfileHeaderCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = AppFont.h2
        titleLabel.textColor = AppColor.textPrimary
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }

    func configure(imageUrl: URL?, title: String) {
        titleLabel.text = title
        
        if let url = imageUrl {
            profileImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            )
        } else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        }
    }
}
