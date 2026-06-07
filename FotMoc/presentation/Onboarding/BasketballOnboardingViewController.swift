//
//  BasketballOnboardingViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 30/05/2026.
//

import UIKit

class BasketballOnboardingViewController: UIViewController {

    @IBOutlet var uiview: UIView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var subtitle: UILabel!
        @IBOutlet weak var onBoardingimage: UIImageView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupColors()
            setupIcon()
        }
        
        private func setupColors() {
            view.backgroundColor = AppColor.bgPrimary
            titleLabel.textColor = AppColor.textPrimary
            subtitle.textColor = AppColor.textSecondary
            onBoardingimage.tintColor = AppColor.accentPrimary
        }
        
        private func setupIcon() {
            // Using the built-in basketball SF Symbol
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular)
            let iconImage = UIImage(systemName: "basketball", withConfiguration: symbolConfig)
            
            onBoardingimage.image = iconImage
            onBoardingimage.contentMode = .scaleAspectFit
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
