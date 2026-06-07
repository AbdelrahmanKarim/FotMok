//
//  HeadToHeadViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit
import Factory
import SkeletonView

class HeadToHeadViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @Injected(\.headToHeadPresenter) private var presenter: HeadToHeadPresenter

    var teamId1: String = ""
    var teamId2: String = ""
    var leagueId: String = ""
    var headerTitle: String = ""

    private var upcomingMatch: Match?
    private var previousMatches: [Match] = []
    private var overallRecord: HeadToHeadRecord?
    private var firstTeamForm: TeamRecentForm?
    private var secondTeamForm: TeamRecentForm?

    // Custom overlay overlay view matching details layout pattern
    private lazy var noInternetView: NoInternetOverlayView = {
        let v = NoInternetOverlayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        v.onRetry = { [weak self] in
            self?.presenter.retryLoading()
        }
        return v
    }()

    private let sectionHeaders: [Int: SectionHeader] = [
        0: SectionHeader(title: NSLocalizedString("h2h_upcoming",      comment: ""), iconName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90"),
        1: SectionHeader(title: NSLocalizedString("h2h_form",          comment: ""), iconName: "chart.xyaxis.line"),
        2: SectionHeader(title: NSLocalizedString("h2h_previous",      comment: ""), iconName: "sportscourt"),
        3: SectionHeader(title: NSLocalizedString("h2h_overall",       comment: ""), iconName: "chart.pie")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = AppColor.bgPrimary
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
        registerCells()
        registerHeaders()
        
        setupNoInternetConstraints()
        
        presenter.attachView(self)
        presenter.loadData(teamId1: teamId1, teamId2: teamId2, leagueId: leagueId)
    }

    deinit { presenter.detachView() }

    private func registerCells() {
        collectionView.register(UINib(nibName: "UpcomingCollectionViewCell",   bundle: nil), forCellWithReuseIdentifier: "upcomingEventsCell")
        collectionView.register(UINib(nibName: "RecentFormCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "recentFormCell")
        collectionView.register(UINib(nibName: "LatestEventCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "latestEventCell")
        collectionView.register(UINib(nibName: "OverallH2HCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "overallH2HCell")
        collectionView.register(UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "emptyState")
    }

    private func registerHeaders() {
        collectionView.register(UINib(nibName: "LeagueDetailsHeader",  bundle: nil),
            forSupplementaryViewOfKind: "GlobalHeaderKind", withReuseIdentifier: "leagueDetailsHeader")
        collectionView.register(UINib(nibName: "CustomSectionHeader",  bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "customHeader")
    }
    
    private func setupNoInternetConstraints() {
        view.addSubview(noInternetView)
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 100), // Pushed past global header
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HeadToHeadViewController: HeadToHeadView {

    func showLoading() {
        collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }

    func hideLoading(then completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            completion?()
        }
    }

    func showNoInternet() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.noInternetView.isHidden = false
        }
    }

    func hideNoInternet() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.noInternetView.isHidden = true
        }
    }

    func displayUpcomingMatch(_ match: Match?) {
        upcomingMatch = match
        collectionView.reloadSections(IndexSet(integer: 0))
    }

    func displayRecentForm(firstTeam: TeamRecentForm, secondTeam: TeamRecentForm) {
        firstTeamForm  = firstTeam
        secondTeamForm = secondTeam
        collectionView.reloadSections(IndexSet(integer: 1))
    }

    func displayPreviousMatches(_ matches: [Match]) {
        previousMatches = matches
        collectionView.reloadSections(IndexSet(integer: 2))
    }

    func displayOverallRecord(_ record: HeadToHeadRecord) {
        overallRecord = record
        collectionView.reloadSections(IndexSet(integer: 3))
    }

    func displayError(message: String) {
        hideLoading(then: nil)
        print("H2H error: \(message)")
    }

    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension HeadToHeadViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int { 4 }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return previousMatches.isEmpty ? 1 : previousMatches.count
        case 3: return 1
        default: return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {

        case 0:
            if let match = upcomingMatch {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "upcomingEventsCell", for: indexPath) as! UpcomingCollectionViewCell
                cell.configure(with: match)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
                cell.configure(message: NSLocalizedString("empty_no_upcoming", comment: ""),
                               iconName: "calendar.badge.minus")
                return cell
            }

        case 1:
            guard let f1 = firstTeamForm, let f2 = secondTeamForm else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
                cell.configure(
                    message: NSLocalizedString("empty_no_form", comment: ""),
                    iconName: "chart.xyaxis.line"
                )
                return cell
            }
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "recentFormCell", for: indexPath) as! RecentFormCollectionViewCell
            cell.configure(firstTeam: f1, secondTeam: f2)
            return cell

        case 2:
            if previousMatches.isEmpty {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
                cell.configure(message: NSLocalizedString("empty_no_latest", comment: ""),
                               iconName: "sportscourt")
                return cell
            }
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
            cell.configure(with: previousMatches[indexPath.item])
            return cell

        case 3:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "overallH2HCell", for: indexPath) as! OverallH2HCollectionViewCell
            if let r = overallRecord {
                cell.configure(homeWins: "\(r.firstTeamWins)",
                               draws:    "\(r.draws)",
                               awayWins: "\(r.secondTeamWins)")
            }
            return cell

        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "GlobalHeaderKind" {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "leagueDetailsHeader", for: indexPath) as! LeagueDetailsHeader
            header.configure(
                title: headerTitle.isEmpty ? NSLocalizedString("h2h_title", comment: "") : headerTitle,
                country: "",
                showBackButton: true
            )
            header.delegate = self
            return header
        }
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "customHeader", for: indexPath) as! CustomSectionHeader
        if let info = sectionHeaders[indexPath.section] {
            header.configure(title: info.title, iconName: info.iconName)
        }
        return header
    }

    func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, _ in
            self.getSectionFor(index: index)
        }
        layout.configuration = globalHeaderConfiguration()
        return layout
    }

    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: "GlobalHeaderKind", alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
    }

    private func getSectionFor(index: Int) -> NSCollectionLayoutSection {
        switch index {
        case 0: return cardSection(height: 200)
        case 1: return cardSection(height: 200)
        case 2: return cardSection(height: previousMatches.isEmpty ? 150 : 120,
                                   interGroupSpacing: previousMatches.isEmpty ? 0 : 10)
        case 3: return cardSection(height: 120)
        default: return cardSection(height: 150)
        }
    }

    private func cardSection(height: CGFloat, interGroupSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(height)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = [sectionHeaderConfig()]
        return section
    }

    private func sectionHeaderConfig() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(44)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
    }
}

extension HeadToHeadViewController: LeagueDetailsHeaderDelegate {
    func didTapFavourite() { }
    func didSelectTab(index: Int) { }
    func didTapThemeButton() { }
    func didSelectLanguage(_ code: String) { }
    func didTapBackButton() { presenter.didTapBack() }
}

extension HeadToHeadViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch indexPath.section {
        case 0: return "upcomingEventsCell"
        case 1: return "recentFormCell"
        case 2: return "latestEventCell"
        case 3: return "overallH2HCell"
        default: return "upcomingEventsCell"
        }
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 3
        case 3: return 1
        default: return 1
        }
    }
    func numSections(in collectionSkeletonView: UICollectionView) -> Int { 4 }
}
