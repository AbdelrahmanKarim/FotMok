//
//  CustomTabsCollectionReusableView.swift
//  FotMoc
//
//  Created by Alaa Ayman on 31/05/2026.
//

import UIKit

protocol CustomTabsDelegate: AnyObject {
    func didSelectTab(index: Int)
}
class CustomTabsCollectionReusableView: UICollectionReusableView {
    weak var delegate: CustomTabsDelegate?
    @IBOutlet weak var contentUiView: UIView!
    @IBOutlet weak var tabsStackView: UIStackView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet var tabButtons: [UIButton]!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    private func setupUI() {
            contentUiView.backgroundColor = AppColor.accentLight
            indicatorView.backgroundColor = AppColor.accentPrimary
            
            tabButtons.forEach { button in
                button.titleLabel?.font = AppFont.bodyMedium
            }
            
            updateSelectedTab(index: 0, animated: false)
        }
        
        @IBAction func tabButtonTapped(_ sender: UIButton) {
            updateSelectedTab(index: sender.tag, animated: true)
            delegate?.didSelectTab(index: sender.tag)
        }
        
        private func updateSelectedTab(index: Int, animated: Bool) {
            var targetButton: UIButton? = nil
            
            for button in tabButtons {
                let isSelected = button.tag == index
                if isSelected {
                    targetButton = button
                }
            }
            
            guard let selectedButton = targetButton else { return }
            self.layoutIfNeeded()
            
            indicatorLeadingConstraint.constant = selectedButton.frame.origin.x + 16
            
            if animated {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    self.layoutIfNeeded()
                }, completion: nil)
            } else {
                self.layoutIfNeeded()
            }
        }
}
