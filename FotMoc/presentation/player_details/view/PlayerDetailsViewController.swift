import UIKit
import Factory

class PlayerDetailsViewController: UIViewController, PlayerProfileView {

    var collectionView: UICollectionView!
    var playerIdPassed: String = ""

    private var player: Player?
    private var stats: PlayerProfileStats?

    private weak var globalHeader: LeagueDetailsHeader?
    private var headerTitle: String = NSLocalizedString("loading_profile", comment: "")
    
    private var headerTitle: String = ""

    private lazy var noInternetView: NoInternetOverlayView = {
        let v = NoInternetOverlayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        v.onRetry = { [weak self] in
            self?.presenter.retryLoading()
        }
        return v
    }()

    @Injected(\.playerDetailsPresenter) private var presenter: PlayerProfilePresenter

    enum SectionType {
        case profileHeader

        case footballSeason
        case footballAttacking
        case footballDefending
        case footballPassing
        case footballDisciplinary

        case basketballSeason
        case basketballOffense
        case basketballDefense

        case cricketSeason
        case cricketBatting
        case cricketBowling

        case tennisSeason
        case tennisInfo
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
        presenter.loadPlayerData(playerId: playerIdPassed)
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ProfileHeaderCell")
        collectionView.register(UINib(nibName: "statsGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatsGridCell")
        collectionView.register(SectionTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.register(UINib(nibName: "LeagueDetailsHeader", bundle: nil), forSupplementaryViewOfKind: "GlobalHeaderKind", withReuseIdentifier: "leagueDetailsHeader")
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let self = self, sectionIndex < self.sections.count else { return nil }
            let sectionType = self.sections[sectionIndex]
            switch sectionType {
            case .profileHeader:
                return self.createFullWidthSection(height: 220, hasHeader: false)
            default:
                return self.createGridSection()
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
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

    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }

    func showLoading() {}
    func hideLoading() {}
    func showNoInternet() { DispatchQueue.main.async { self.noInternetView.isHidden = false } }
    func hideNoInternet() { DispatchQueue.main.async { self.noInternetView.isHidden = true } }

    func displayPlayerProfile(player: Player, stats: PlayerProfileStats?) {
        self.player = player
        self.stats = stats
        self.headerTitle = player.name
        self.sections = [.profileHeader]

        switch player.sportDetails {

        case .football:
            sections.append(.footballSeason)
            if let s = stats {
                if s.shots ?? 0 > 0 || s.dribbles ?? 0 > 0 || s.keyPasses ?? 0 > 0 || s.penScored ?? 0 > 0 {
                    sections.append(.footballAttacking)
                }
                if s.tackles ?? 0 > 0 || s.blocks ?? 0 > 0 || s.interceptions ?? 0 > 0 || s.clearances ?? 0 > 0 {
                    sections.append(.footballDefending)
                }
                if s.passes ?? 0 > 0 || s.crossesTotal ?? 0 > 0 {
                    sections.append(.footballPassing)
                }
                if s.disciplinary.yellowCards > 0 || s.disciplinary.redCards > 0 {
                    sections.append(.footballDisciplinary)
                }
            }

        case .basketball:
            sections.append(.basketballSeason)
            if let s = stats {
                if s.shots ?? 0 > 0 || s.dribbles ?? 0 > 0 {
                    sections.append(.basketballOffense)
                }
                if s.blocks ?? 0 > 0 || s.tackles ?? 0 > 0 {
                    sections.append(.basketballDefense)
                }
            }

        case .cricket:
            sections.append(.cricketSeason)
            if let s = stats {
                if s.shots ?? 0 > 0 || s.dribbles ?? 0 > 0 {
                    sections.append(.cricketBatting)
                }
                if s.blocks ?? 0 > 0 || s.saves ?? 0 > 0 {
                    sections.append(.cricketBowling)
                }
            }

        case .tennis:
            sections.append(.tennisSeason)
            sections.append(.tennisInfo)
        }

        DispatchQueue.main.async {
            
            self.globalHeader?.configure(
                title: self.headerTitle,
                country: NSLocalizedString("player_profile", comment: ""),
                showTabs: false,
                showBackButton: true,
                showHeader: true,
                showFavBtn: false
            )
            self.collectionView.reloadData()
        }
    }

    func displayError(message: String) {
  
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
                present(alert, animated: true)
        
    }

    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PlayerDetailsViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard player != nil else { return 0 }
        switch sections[section] {
        case .profileHeader:                            return 1
        case .footballSeason:                           return 4
        case .footballAttacking:                        return 4
        case .footballDefending:                        return 4
        case .footballPassing:                          return 4
        case .footballDisciplinary:                     return 2
        case .basketballSeason:                         return 4
        case .basketballOffense:                        return 4
        case .basketballDefense:                        return 2
        case .cricketSeason:                            return 4
        case .cricketBatting:                           return 4
        case .cricketBowling:                           return 4
        case .tennisSeason:                             return 4
        case .tennisInfo:                               return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        let i = indexPath.item

        switch sectionType {

        case .profileHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let p = player { cell.configure(imageUrl: p.imageUrl, title: p.name) }
            return cell

        case .footballSeason:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Goals", "Assists", "Matches", "Rating"]
            let values = [
                "\(stats?.season.goals ?? 0)",
                "\(stats?.season.assists ?? 0)",
                "\(stats?.season.matchesPlayed ?? 0)",
                stats?.season.rating ?? "N/A"
            ]
            let colors: [UIColor] = [.systemGreen, .systemBlue, AppColor.textPrimary, .systemOrange]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .footballAttacking:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Shots", "Dribbles", "Key Passes", "Pen Scored"]
            let values = [
                "\(stats?.shots ?? 0)",
                "\(stats?.dribbles ?? 0)",
                "\(stats?.keyPasses ?? 0)",
                "\(stats?.penScored ?? 0)"
            ]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .footballDefending:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Tackles", "Blocks", "Interceptions", "Clearances"]
            let values = [
                "\(stats?.tackles ?? 0)",
                "\(stats?.blocks ?? 0)",
                "\(stats?.interceptions ?? 0)",
                "\(stats?.clearances ?? 0)"
            ]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .footballPassing:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Passes", "Pass Acc %", "Crosses", "Duels Won"]
            let values = [
                "\(stats?.passes ?? 0)",
                stats?.passAccuracy ?? "N/A",
                "\(stats?.crossesTotal ?? 0)",
                "\(stats?.duelsWon ?? 0)"
            ]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .footballDisciplinary:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Yellow Cards", "Red Cards"]
            let values = ["\(stats?.disciplinary.yellowCards ?? 0)", "\(stats?.disciplinary.redCards ?? 0)"]
            let colors: [UIColor] = [.systemYellow, .systemRed]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .basketballSeason:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Points", "Assists", "Matches", "Minutes"]
            let values = [
                "\(stats?.season.goals ?? 0)",
                "\(stats?.season.assists ?? 0)",
                "\(stats?.season.matchesPlayed ?? 0)",
                "\(stats?.season.minutesPlayed ?? 0)"
            ]
            let colors: [UIColor] = [.systemOrange, .systemBlue, AppColor.textPrimary, AppColor.textPrimary]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .basketballOffense:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Field Goals", "Dribbles", "Duels Won", "Duels Total"]
            let values = [
                "\(stats?.shots ?? 0)",
                "\(stats?.dribbles ?? 0)",
                "\(stats?.duelsWon ?? 0)",
                "\(stats?.duelsTotal ?? 0)"
            ]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .basketballDefense:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Blocks", "Steals"]
            let values = ["\(stats?.blocks ?? 0)", "\(stats?.tackles ?? 0)"]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .cricketSeason:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Runs", "Innings", "Matches", "Avg"]
            let innings = stats?.season.matchesPlayed ?? 1
            let runs = stats?.season.goals ?? 0
            let avg = innings > 0 ? String(format: "%.1f", Double(runs) / Double(innings)) : "N/A"
            let values = ["\(runs)", "\(innings)", "\(stats?.season.matchesPlayed ?? 0)", avg]
            let colors: [UIColor] = [.systemGreen, AppColor.textPrimary, AppColor.textPrimary, .systemOrange]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .cricketBatting:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Boundaries", "Sixes", "Strike Rate", "50s"]
            let values = [
                "\(stats?.shots ?? 0)",
                "\(stats?.dribbles ?? 0)",
                stats?.passAccuracy ?? "N/A",
                "\(stats?.assists ?? 0)"
            ]
            cell.configure(title: titles[i], value: values[i], valueColor: AppColor.textPrimary)
            return cell

        case .cricketBowling:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Wickets", "Economy", "Maidens", "Best"]
            let values = [
                "\(stats?.blocks ?? 0)",
                stats?.season.rating ?? "N/A",
                "\(stats?.saves ?? 0)",
                "\(stats?.interceptions ?? 0)"
            ]
            let colors: [UIColor] = [.systemPurple, AppColor.textPrimary, AppColor.textPrimary, AppColor.textPrimary]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .tennisSeason:
            let cell = dequeueStatsCell(collectionView, indexPath)
            let titles = ["Matches", "Wins", "Losses", "Win Rate"]
            let matches = stats?.season.matchesPlayed ?? 0
            let wins = stats?.season.goals ?? 0
            let losses = matches - wins
            let winRate = matches > 0 ? String(format: "%.0f%%", Double(wins) / Double(matches) * 100) : "N/A"
            let values = ["\(matches)", "\(wins)", "\(losses)", winRate]
            let colors: [UIColor] = [AppColor.textPrimary, .systemGreen, .systemRed, .systemBlue]
            cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            return cell

        case .tennisInfo:
            let cell = dequeueStatsCell(collectionView, indexPath)
            if case .tennis(let rank, let plays) = player?.sportDetails {
                let titles = ["Rank", "Plays"]
                let values = [rank != nil ? "\(rank!)" : "N/A", plays ?? "N/A"]
                let colors: [UIColor] = [.systemBlue, AppColor.textPrimary]
                cell.configure(title: titles[i], value: values[i], valueColor: colors[i])
            }
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
        case .footballSeason:       header.titleLabel.text = "SEASON STATS"
        case .footballAttacking:    header.titleLabel.text = "ATTACKING"
        case .footballDefending:    header.titleLabel.text = "DEFENDING"
        case .footballPassing:      header.titleLabel.text = "PASSING"
        case .footballDisciplinary: header.titleLabel.text = "DISCIPLINARY"
        case .basketballSeason:     header.titleLabel.text = "SEASON STATS"
        case .basketballOffense:    header.titleLabel.text = "OFFENSE"
        case .basketballDefense:    header.titleLabel.text = "DEFENSE"
        case .cricketSeason:        header.titleLabel.text = "SEASON STATS"
        case .cricketBatting:       header.titleLabel.text = "BATTING"
        case .cricketBowling:       header.titleLabel.text = "BOWLING"
        case .tennisSeason:         header.titleLabel.text = "SEASON STATS"
        case .tennisInfo:           header.titleLabel.text = "PLAYER INFO"
        default:                    header.titleLabel.text = ""
        }
        return header
        
    }
}

extension PlayerDetailsViewController: LeagueDetailsHeaderDelegate {
    func didTapBackButton() { presenter.didTapBack() }
    func didSelectTab(index: Int) {}
    func didTapFavourite() {}
    func didTapThemeButton() {}
    func didSelectLanguage(_ code: String) {}
}

class SectionTitleHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AppFont.caption
        titleLabel.textColor = AppColor.textSecondary
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

private extension PlayerProfileStats {
    var assists: Int { return season.assists }
}
