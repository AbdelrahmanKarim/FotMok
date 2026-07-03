//
//  FootballOnboardingViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 30/05/2026.
//

import UIKit

class FootballOnboardingViewController: UIViewController {

    @IBOutlet var uiview: UIView!
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var onBoardingimage: UIImageView!
    override func viewDidLoad() {
            super.viewDidLoad()
            setupColors()
            setupIcon()
        }
        
        private func setupColors() {
            // 1. Background
            view.backgroundColor = AppColor.bgPrimary
            
            // 2. Typography
            titleLabel.textColor = AppColor.textPrimary
            subtitle.textColor = AppColor.textSecondary
            
            // 3. Icon Tint Color
            onBoardingimage.tintColor = AppColor.accentPrimary
        }
        
        private func setupIcon() {
            // Use the built-in soccerball SF Symbol
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular)
            let iconImage = UIImage(systemName: "soccerball", withConfiguration: symbolConfig)
            
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
