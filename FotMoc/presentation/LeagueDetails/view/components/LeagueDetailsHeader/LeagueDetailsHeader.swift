//
//  LeagueDetailsHeader.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//


import UIKit


protocol LeagueDetailsHeaderDelegate: AnyObject {

    func didSelectTab(index: Int)
    func didTapBackButton()
    func didTapFavourite()

}
class LeagueDetailsHeader: UICollectionReusableView {
    
    weak var delegate: LeagueDetailsHeaderDelegate?
    
    
    @IBOutlet weak var headerStackView: UIStackView!
  
    
    @IBOutlet weak var contentUiView: UIView!
    @IBOutlet weak var tabsStackView: UIStackView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet var tabButtons: [UIButton]!
    
    @IBOutlet weak var favBtn: UIButton!
    
    @IBOutlet weak var leagueTitle: UILabel!
    @IBOutlet weak var leagueCountry: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {

          contentUiView.layer.cornerRadius = 24
          contentUiView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
          contentUiView.clipsToBounds = true
          contentUiView.backgroundColor = AppColor.accentLight
          indicatorView.backgroundColor = AppColor.accentPrimary
          backBtn.layer.cornerRadius = backBtn.frame.height / 2

          backBtn.clipsToBounds = true
          leagueTitle.font = AppFont.h1
          leagueCountry.font = AppFont.small
          tabButtons.forEach {button in button.titleLabel?.font = AppFont.bodyMedium}
          updateSelectedTab(index: 0, animated: false)

          

      }
    
    @IBAction func favBtn(_ sender: Any) {
        delegate?.didTapFavourite()
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

      
    @IBAction func backButtonTapped(_ sender: UIButton) {
        delegate?.didTapBackButton()
    }
    func updateFavouriteState(isFavourite: Bool) {
        let imageName = isFavourite ? "heart.fill" : "heart"
        let color: UIColor = isFavourite ? .red : .white
        
        if var config = favBtn.configuration {
            config.image = UIImage(systemName: imageName)
            config.baseForegroundColor = color
            favBtn.configuration = config
        } else {
            favBtn.setImage(UIImage(systemName: imageName), for: .normal)
            favBtn.tintColor = color
        }
    }
    
    func configure(title: String, country: String , showTabs : Bool = false , showBackButton : Bool = true , showHeader : Bool = true , showFavBtn :Bool = false) {

            leagueTitle.text = title

            leagueCountry.text = country

            tabsStackView.isHidden = !showTabs

            indicatorView.isHidden = !showTabs
            backBtn.isHidden = !showBackButton
            headerStackView.isHidden = !showHeader
             favBtn.isHidden = !showFavBtn
        }
    }
    
