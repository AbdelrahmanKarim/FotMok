//
//  TeamDetailsViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 30/05/2026.
//

import UIKit
import Factory

class TeamDetailsViewController: UIViewController, TeamDetailsView {

    var collectionView: UICollectionView!
    var teamIdPassed: String = ""
    var leagueIdPassed: String = ""

    private var team: Team?
    private var stats: TeamSeasonStats?
    private var players: [Player] = []

    private weak var globalHeader: LeagueDetailsHeader?
    private var headerTitle: String = NSLocalizedString("loading_team", comment: "")

    private lazy var noInternetView: NoInternetOverlayView = {
        let v = NoInternetOverlayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        v.onRetry = { [weak self] in
            self?.presenter.retryLoading()
        }
        return v
    }()

    @Injected(\.teamDetailsPresenter) private var presenter: TeamDetailsPresenter

    enum SectionType {
        case profileHeader

        case footballOverview
        case footballAttack
        case footballDefence

        case basketballOverview
        case basketballOffense
        case basketballDefense

        case cricketOverview
        case cricketBatting
        case cricketBowling

        case keyPlayers
        case about
    }

    private var sections: [SectionType] = [.profileHeader]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupCollectionView()

        view.addSubview(noInternetView)
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 100),
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        presenter.attachView(self)
        presenter.loadTeamData(teamId: teamIdPassed, leagueId: leagueIdPassed)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ProfileHeaderCell")
        collectionView.register(UINib(nibName: "statsGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatsGridCell")
        collectionView.register(UINib(nibName: "KeyPlayerCell", bundle: nil), forCellWithReuseIdentifier: "KeyPlayerCell")
        collectionView.register(UINib(nibName: "AboutTeamCell", bundle: nil), forCellWithReuseIdentifier: "AboutTeamCell")
        collectionView.register(SectionTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.register(UINib(nibName: "LeagueDetailsHeader", bundle: nil), forSupplementaryViewOfKind: "GlobalHeaderKind", withReuseIdentifier: "leagueDetailsHeader")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self = self, sectionIndex < self.sections.count else { return nil }
            switch self.sections[sectionIndex] {
            case .profileHeader:
                return self.createFullWidthSection(height: 240, hasHeader: false)
            case .footballOverview, .footballAttack, .footballDefence,
                 .basketballOverview, .basketballOffense, .basketballDefense,
                 .cricketOverview, .cricketBatting, .cricketBowling:
                return self.createGridSection()
            case .keyPlayers:
                if self.players.isEmpty {
                    let dummyItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0.1), heightDimension: .absolute(0.1)))
                    let dummyGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(0.1), heightDimension: .absolute(0.1)), subitems: [dummyItem])
                    return NSCollectionLayoutSection(group: dummyGroup)
                }
                return self.createHorizontalScrollSection()
            case .about:
                return self.createFullWidthSection(height: 150, hasHeader: true)
            }
        }
        layout.configuration = globalHeaderConfiguration()
        return layout
    }

    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "GlobalHeaderKind", alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
    }

    private func createFullWidthSection(height: CGFloat, hasHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16)
        if hasHeader { section.boundarySupplementaryItems = [createSectionHeader()] }
        return section
    }

    private func createGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 10, bottom: 24, trailing: 10)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }

    private func createHorizontalScrollSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }

    func showLoading() {}
    func hideLoading() {}

    func showNoInternet() { DispatchQueue.main.async { self.noInternetView.isHidden = false } }
    func hideNoInternet() { DispatchQueue.main.async { self.noInternetView.isHidden = true } }

    func displayTeamDetails(team: Team, stats: TeamSeasonStats?, players: [Player]) {
        self.team = team
        self.stats = stats
        self.players = players
        self.headerTitle = team.name

        buildSections(for: team.sport, stats: stats)

        DispatchQueue.main.async {
            
            self.globalHeader?.configure(
                title: self.headerTitle,
                country: NSLocalizedString("team_profile", comment: ""),
                showTabs: false,
                showBackButton: true,
                showHeader: true,
                showFavBtn: false
            )
            self.collectionView.reloadData()
        }
    }

    private func buildSections(for sport: SportType, stats: TeamSeasonStats?) {
        sections = [.profileHeader]

        switch sport {
        case .football:
            sections.append(.footballOverview)
            if let s = stats, (s.goalsFor > 0 || s.goalDifference != 0) {
                sections.append(.footballAttack)
            }
            if let s = stats, (s.goalsAgainst > 0 || s.cleanSheets > 0) {
                sections.append(.footballDefence)
            }

        case .basketball:
            sections.append(.basketballOverview)
            if let s = stats, s.fieldGoalsMade > 0 {
                sections.append(.basketballOffense)
            }
            if let s = stats, s.avgReboundsPerGame > 0 {
                sections.append(.basketballDefense)
            }

        case .cricket:
            sections.append(.cricketOverview)
            if let s = stats, s.runsScored > 0 {
                sections.append(.cricketBatting)
            }
            if let s = stats, s.wicketsTaken > 0 {
                sections.append(.cricketBowling)
            }

        default:
            sections.append(.footballOverview)
        }

        if !players.isEmpty { sections.append(.keyPlayers) }
        sections.append(.about)
    }

    func displayError(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
        present(alert, animated: true)
    }

    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }

    func navigateToPlayerProfile(playerId: String) {
        guard let playerVC = storyboard?.instantiateViewController(withIdentifier: "playerDetailsScreen") as? PlayerDetailsViewController else { return }
        playerVC.playerIdPassed = playerId
        navigationController?.pushViewController(playerVC, animated: true)
    }
}

extension TeamDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard team != nil else { return 0 }
        switch sections[section] {
        case .profileHeader:                                        return 1
        case .footballOverview, .footballAttack, .footballDefence:  return 4
        case .basketballOverview:                                   return 4
        case .basketballOffense:                                    return 4
        case .basketballDefense:                                    return 2
        case .cricketOverview:                                      return 4
        case .cricketBatting:                                       return 4
        case .cricketBowling:                                       return 2
        case .keyPlayers:                                           return players.count
        case .about:                                                return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        let i = indexPath.item

        switch sectionType {

        case .profileHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let t = team { cell.configure(imageUrl: t.logoUrl, title: t.name) }
            return cell

        case .footballOverview:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("points", comment: ""), NSLocalizedString("matches", comment: ""), NSLocalizedString("wins", comment: ""), NSLocalizedString("goal_diff", comment: "")]
            let values = [
                "\(stats?.points ?? 0)",
                "\(stats?.matchesPlayed ?? 0)",
                "\(stats?.wins ?? 0)",
                "\(stats?.goalDifference ?? 0)"
            ]
            let colors: [UIColor] = [.systemGreen, AppColor.textPrimary, .systemBlue, stats?.goalDifference ?? 0 >= 0 ? .systemGreen : .systemRed]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .footballAttack:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("goals_for", comment: ""), NSLocalizedString("goals_against", comment: ""), NSLocalizedString("draws", comment: ""), NSLocalizedString("losses", comment: "")]
            let values = [
                "\(stats?.goalsFor ?? 0)",
                "\(stats?.goalsAgainst ?? 0)",
                "\(stats?.draws ?? 0)",
                "\(stats?.losses ?? 0)"
            ]
            let colors: [UIColor] = [.systemGreen, .systemRed, .systemOrange, .systemRed]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .footballDefence:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("clean_sheets", comment: ""), NSLocalizedString("goals_conceded", comment: ""), NSLocalizedString("draws", comment: ""), NSLocalizedString("losses", comment: "")]
            let values = [
                "\(stats?.cleanSheets ?? 0)",
                "\(stats?.goalsAgainst ?? 0)",
                "\(stats?.draws ?? 0)",
                "\(stats?.losses ?? 0)"
            ]
            let colors: [UIColor] = [.systemBlue, .systemRed, .systemOrange, .systemRed]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .basketballOverview:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("matches", comment: ""), NSLocalizedString("avg_pts", comment: ""), NSLocalizedString("avg_reb", comment: ""), NSLocalizedString("avg_ast", comment: "")]
            let values = [
                "\(stats?.matchesPlayed ?? 0)",
                String(format: "%.1f", stats?.avgPointsPerGame ?? 0),
                String(format: "%.1f", stats?.avgReboundsPerGame ?? 0),
                String(format: "%.1f", stats?.avgAssistsPerGame ?? 0)
            ]
            let colors: [UIColor] = [AppColor.textPrimary, .systemOrange, .systemBlue, .systemGreen]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .basketballOffense:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("fg_made", comment: ""), NSLocalizedString("fg_attempts", comment: ""), NSLocalizedString("3_pointers", comment: ""), NSLocalizedString("total_pts", comment: "")]
            let values = [
                "\(stats?.fieldGoalsMade ?? 0)",
                "\(stats?.fieldGoalsAttempted ?? 0)",
                "\(stats?.threePointersMade ?? 0)",
                "\(stats?.points ?? 0)"
            ]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .basketballDefense:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("blocks", comment: ""), NSLocalizedString("wins", comment: "")]
            let values = ["\(stats?.cleanSheets ?? 0)", "\(stats?.wins ?? 0)"]
            let colors: [UIColor] = [.systemPurple, .systemGreen]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .cricketOverview:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("matches", comment: ""), NSLocalizedString("wins", comment: ""), NSLocalizedString("nrr", comment: ""), NSLocalizedString("points", comment: "")]
            let values = [
                "\(stats?.matchesPlayed ?? 0)",
                "\(stats?.wins ?? 0)",
                String(format: "%.3f", stats?.nrr ?? 0),
                "\(stats?.points ?? 0)"
            ]
            let colors: [UIColor] = [AppColor.textPrimary, .systemGreen, stats?.nrr ?? 0 >= 0 ? .systemGreen : .systemRed, .systemOrange]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .cricketBatting:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("runs_scored", comment: ""), NSLocalizedString("highest_score", comment: ""), NSLocalizedString("centuries", comment: ""), NSLocalizedString("half_cents", comment: "")]
            let values = [
                "\(stats?.runsScored ?? 0)",
                "\(stats?.highestScore ?? 0)",
                "\(stats?.centuries ?? 0)",
                "\(stats?.halfCenturies ?? 0)"
            ]
            let colors: [UIColor] = [.systemGreen, .systemBlue, .systemOrange, AppColor.textPrimary]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .cricketBowling:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = [NSLocalizedString("wickets", comment: ""), NSLocalizedString("losses", comment: "")]
            let values = ["\(stats?.wicketsTaken ?? 0)", "\(stats?.losses ?? 0)"]
            let colors: [UIColor] = [.systemPurple, .systemRed]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .keyPlayers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyPlayerCell", for: indexPath) as! KeyPlayerCell
            cell.configure(player: players[i])
            return cell

        case .about:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutTeamCell", for: indexPath) as! AboutTeamCell
            cell.configure(text: team?.description ?? NSLocalizedString("no_description", comment: ""))
            return cell
        }
    }

    private func dequeueStatsCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> statsGridCollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "StatsGridCell", for: indexPath) as! statsGridCollectionViewCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "GlobalHeaderKind" {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "leagueDetailsHeader", for: indexPath) as! LeagueDetailsHeader
            self.globalHeader = header
            header.configure(title: headerTitle, country: "", showTabs: false, showBackButton: true, showHeader: true, showFavBtn: false)
            header.delegate = self
            return header
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionTitleHeaderView
        
        switch sections[indexPath.section] {
        case .footballOverview, .basketballOverview, .cricketOverview:
            header.titleLabel.text = NSLocalizedString("overview", comment: "")
        case .footballAttack:    header.titleLabel.text = NSLocalizedString("attack", comment: "")
        case .footballDefence:   header.titleLabel.text = NSLocalizedString("defence", comment: "")
        case .basketballOffense: header.titleLabel.text = NSLocalizedString("offense", comment: "")
        case .basketballDefense: header.titleLabel.text = NSLocalizedString("defense", comment: "")
        case .cricketBatting:    header.titleLabel.text = NSLocalizedString("batting", comment: "")
        case .cricketBowling:    header.titleLabel.text = NSLocalizedString("bowling", comment: "")
        case .keyPlayers:        header.titleLabel.text = NSLocalizedString("key_players", comment: "")
        case .about:             header.titleLabel.text = NSLocalizedString("about", comment: "")
        default:                 header.titleLabel.text = ""
        }
        
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if sections[indexPath.section] == .keyPlayers {
            presenter.didSelectPlayer(at: indexPath.item)
        }
    }
}

extension TeamDetailsViewController: LeagueDetailsHeaderDelegate {
    func didTapBackButton() { presenter.didTapBack() }
    func didSelectTab(index: Int) {}
    func didTapFavourite() {}
    func didTapThemeButton() {}
    func didSelectLanguage(_ code: String) {}
}
