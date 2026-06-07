//
//  TennisOnboardingViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 30/05/2026.
//

import UIKit

class TennisOnboardingViewController: UIViewController {
    @IBOutlet weak var getStartedBtn: UIButton!
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
            // Using the built-in tennisball SF Symbol
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular)
            let iconImage = UIImage(systemName: "tennisball", withConfiguration: symbolConfig)
            
            onBoardingimage.image = iconImage
            onBoardingimage.contentMode = .scaleAspectFit
        }
    
    @IBAction func getStartedBtn(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let mainTabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else { return }
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate,
                  let window = sceneDelegate.window else { return }
            
            mainTabBarVC.selectedIndex = 0
            window.rootViewController = mainTabBarVC
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
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
