//
//  LatestEventsFooter.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//
import UIKit

class LatestEventsFooter: UICollectionReusableView {

    var showMoreAction: (() -> Void)?
    let showMoreButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.bgPrimary
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        showMoreButton.setTitle(NSLocalizedString("show_more", comment: ""), for: .normal)
        showMoreButton.setTitle("Show more", for: .normal)
        showMoreButton.titleLabel?.font = AppFont.bodyMedium
        showMoreButton.setTitleColor(AppColor.info, for: .normal)
  
        addSubview(showMoreButton)
        
      
        showMoreButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showMoreButton.topAnchor.constraint(equalTo: topAnchor),
            showMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            showMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            showMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    
        showMoreButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
 
    @objc private func buttonTapped() {
       
        showMoreAction?()
    }
}
