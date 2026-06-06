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
    func didTapThemeButton()
    func didSelectLanguage(_ code: String)
}

class LeagueDetailsHeader: UICollectionReusableView {

    @IBOutlet weak var actionBtnsStackview: UIStackView!
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
    @IBOutlet weak var localMenuBtn: UIButton!
    @IBOutlet weak var themeBtn: UIButton!


    private var pendingTabIndex: Int = 0
    private var indicatorLeftConstraint: NSLayoutConstraint?

 

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
      
        moveIndicator(to: pendingTabIndex, animated: false)
    }



    private func setupUI() {
        contentUiView.layer.cornerRadius = 24
        contentUiView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentUiView.clipsToBounds = true
        indicatorView.backgroundColor = AppColor.accentPrimary
        backBtn.layer.cornerRadius = backBtn.frame.height / 2
        backBtn.clipsToBounds = true
        leagueTitle.font   = AppFont.h1
        leagueCountry.font = AppFont.small
        tabButtons.forEach { $0.titleLabel?.font = AppFont.bodyMedium }
        setupAbsoluteIndicatorConstraint()
        setupTabTitles()
        setupLanguageMenu()
        applyColors()
    }

    
   
    private func setupAbsoluteIndicatorConstraint() {
        
        indicatorLeadingConstraint.isActive = false

        guard let superview = indicatorView.superview else { return }
        let left = NSLayoutConstraint(
            item: indicatorView!,
            attribute: .left,
            relatedBy: .equal,
            toItem: superview,
            attribute: .left,
            multiplier: 1.0,
            constant: 16
        )
        left.isActive = true
        indicatorLeftConstraint = left
    }

    private func setupTabTitles() {
        let titles: [Int: String] = [
            0: NSLocalizedString("tab_overview",    comment: "Overview tab"),
            1: NSLocalizedString("tab_table",       comment: "Table tab"),
            2: NSLocalizedString("tab_top_scorers", comment: "Top scorers tab")
        ]
        for button in tabButtons {
            if let title = titles[button.tag] {
                button.setTitle(title, for: .normal)
            }
        }
    }

    private func setupLanguageMenu() {
        localMenuBtn.menu = buildLanguageMenu()
        localMenuBtn.showsMenuAsPrimaryAction = true
    }

    private func buildLanguageMenu() -> UIMenu {
        let currentCode = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"

        let english = UIAction(
            title: NSLocalizedString("language_english", comment: ""),
            image: UIImage(systemName: "e.circle"),
            state: currentCode == "en" ? .on : .off
        ) { [weak self] _ in
            self?.delegate?.didSelectLanguage("en")
            self?.localMenuBtn.menu = self?.buildLanguageMenu()
        }

        let arabic = UIAction(
            title: NSLocalizedString("language_arabic", comment: ""),
            image: UIImage(systemName: "a.circle"),
            state: currentCode == "ar" ? .on : .off
        ) { [weak self] _ in
            self?.delegate?.didSelectLanguage("ar")
            self?.localMenuBtn.menu = self?.buildLanguageMenu()
        }

        return UIMenu(
            title: NSLocalizedString("language_menu_title", comment: ""),
            children: [english, arabic]
        )
    }
    private func applyColors() {
        contentUiView.backgroundColor = AppColor.accentLight
    }

   

    private func moveIndicator(to index: Int, animated: Bool) {
        pendingTabIndex = index

        guard let leftConstraint = indicatorLeftConstraint,
              let selectedButton = tabButtons.first(where: { $0.tag == index }),
              selectedButton.frame.width > 0 else { return }

        let buttonFrame = selectedButton.convert(selectedButton.bounds, to: indicatorView.superview)
        let targetConstant = buttonFrame.minX + 16

        
        guard abs(leftConstraint.constant - targetConstant) > 0.5 else { return }

        leftConstraint.constant = targetConstant

        if animated {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.superview?.layoutIfNeeded()
            }
        }
    }


    func updateThemeIcon(isDark: Bool) {
        let image = UIImage(systemName: isDark ? "moon.fill" : "sun.max.fill")
        themeBtn.setImage(image, for: .normal)
        themeBtn.setTitle(nil, for: .normal)
    }

    func configure(title: String,
                   country: String,
                   showTabs: Bool = false,
                   showBackButton: Bool = true,
                   showHeader: Bool = true,
                   showFavBtn: Bool = false,
                   showThemeBtn: Bool = false,
                   showLocalMenu: Bool = false ,
                   showActionBtnStackView : Bool = false) {
        leagueTitle.text         = title
        leagueCountry.text       = country
        tabsStackView.isHidden   = !showTabs
        indicatorView.isHidden   = !showTabs
        backBtn.isHidden         = !showBackButton
        headerStackView.isHidden = !showHeader
        favBtn.isHidden          = !showFavBtn
        themeBtn.isHidden        = !showThemeBtn
        localMenuBtn.isHidden    = !showLocalMenu
        actionBtnsStackview.isHidden = !showActionBtnStackView
    }

    

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        applyColors()
    }


    @IBAction func tabButtonTapped(_ sender: UIButton) {
        moveIndicator(to: sender.tag, animated: true)
        delegate?.didSelectTab(index: sender.tag)
    }

    @IBAction func themeBtn(_ sender: Any) {
        delegate?.didTapThemeButton()
    }

    @IBAction func favBtn(_ sender: Any) { }

    @IBAction func backButtonTapped(_ sender: UIButton) {
        delegate?.didTapBackButton()
    }
}
