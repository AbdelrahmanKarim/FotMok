//
//  HomeCollectionViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 20/05/2026.
//

import UIKit
import Factory

class HomeCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @Injected(\.homePresenter) private var presenter: HomePresenter
    let sports: [SportCell] = [
        SportCell(title: "football",    imageName: "football"),
        SportCell(title: "basketball",  imageName: "basketball"),
        SportCell(title: "tennis",      imageName: "tennis"),
        SportCell(title: "cricket",     imageName: "cricket")
    ]

    

    private weak var homeHeader: LeagueDetailsHeader?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppColor.bgPrimary
        view.backgroundColor = AppColor.bgPrimary
        registerHeaders()

        
      
    }

    deinit {
        presenter.detachView()
    }

   

    func applyTheme(isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene }).first,
              let window = windowScene.windows.first else { return }

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }

  
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard UserDefaults.standard.object(forKey: "isDarkMode") == nil,
              traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        let isDark = traitCollection.userInterfaceStyle == .dark
        homeHeader?.updateThemeIcon(isDark: isDark)
    }

  

    func registerHeaders() {
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(
            globalHeaderNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "leagueDetailsHeader"
        )
    }
}



extension HomeCollectionViewController: HomeView {

    func navigateToLeagues(with sport: SportType) {
        guard let leaguesVC = storyboard?
            .instantiateViewController(withIdentifier: "leaguesScreen") as? LeaguesViewController
        else { return }
        navigationController?.pushViewController(leaguesVC, animated: true)
        leaguesVC.sport = sport
    }

    func updateThemeIcon(isDark: Bool) {
        homeHeader?.updateThemeIcon(isDark: isDark)
    }
    func showRestartAlert() {
         let alert = UIAlertController(
             title:   NSLocalizedString("restart_title", comment: ""),
             message: NSLocalizedString("restart_message", comment: ""),
             preferredStyle: .alert
         )
         alert.addAction(UIAlertAction(
             title: NSLocalizedString("ok_button", comment: ""),
             style: .default
         ))
         present(alert, animated: true)
     }
    
}



extension HomeCollectionViewController: LeagueDetailsHeaderDelegate {

    func didSelectTab(index: Int) { }

    func didTapBackButton() { }

    func didTapThemeButton() {
        presenter.toggleTheme()
    }
    func didSelectLanguage(_ code: String) { presenter.selectLanguage(code) }
}



extension HomeCollectionViewController: UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { sports.count }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        presenter.selectSport(at: indexPath.item, from: sports)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell", for: indexPath) as! CustomHomeCollectionViewCell
        let sport = sports[indexPath.item]
        cell.sportImage.image = UIImage(named: sport.imageName)
        cell.sportTitle.text = NSLocalizedString(sport.title, comment: "Sport name")
        return cell
    }


    private var isLandscape: Bool { view.bounds.width > view.bounds.height }
    private var columns: CGFloat  { isLandscape ? 4 : 2 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 16 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 16
        let totalSpacing = padding * (columns + 1)
        let itemWidth = (collectionView.bounds.width - totalSpacing) / columns
        var itemHeight = itemWidth

        if isLandscape {
            let availableHeight = collectionView.bounds.height - padding * 2
            let w = (collectionView.frame.width - totalSpacing) / 4
            itemHeight = min(w, availableHeight) + 100
        }

        let numRows = ceil(CGFloat(sports.count) / columns)
        let totalItemsHeight = (itemHeight * numRows) + (padding * (numRows - 1))
        let headerHeight: CGFloat = 100
        let totalContentHeight = headerHeight + totalItemsHeight

        if totalContentHeight < collectionView.bounds.height {
            let topInset = (collectionView.bounds.height - totalContentHeight) / 2
            return UIEdgeInsets(top: topInset, left: padding, bottom: padding, right: padding)
        }
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let totalSpacing = padding * (columns + 1)
        let width = (collectionView.bounds.width - totalSpacing) / columns

        if isLandscape {
            let availableHeight = collectionView.bounds.height - padding * 2
            let w = (collectionView.frame.width - totalSpacing) / 4
            let size = min(w, availableHeight)
            return CGSize(width: w, height: size + 100)
        }
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "leagueDetailsHeader",
            for: indexPath) as! LeagueDetailsHeader

        header.configure(
            title: NSLocalizedString("sports_title", comment: "Home screen header"),
            country: "",
            showBackButton: false,
            showThemeBtn: true,
            showLocalMenu: true,
            showActionBtnStackView: true
        )

        header.delegate = self
        homeHeader = header
        header.updateThemeIcon(isDark: presenter.currentThemeIsDark())

        return header
    }
}
