class NoInternetOverlayView: UIView {

    var onRetry: (() -> Void)?

    private let iconView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
        iv.image = UIImage(systemName: "wifi.slash", withConfiguration: config)
        iv.tintColor = AppColor.accentPrimary
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "No Internet Connection"
        l.font = AppFont.h3
        l.textColor = AppColor.textPrimary
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Check your connection and try again."
        l.font = AppFont.caption
        l.textColor = AppColor.textSecondary
        l.textAlignment = .center
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var retryButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Retry", for: .normal)
        b.titleLabel?.font = AppFont.bodyMedium
        b.setTitleColor(AppColor.accentPrimary, for: .normal)
        b.backgroundColor = AppColor.bgSurface3
        b.layer.cornerRadius = 12
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 32, bottom: 10, right: 32)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.bgPrimary
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, subtitleLabel, retryButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            iconView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func retryTapped() { onRetry?() }
}


import UIKit

class NoInternetConnectionOverlay: UIView {


}
