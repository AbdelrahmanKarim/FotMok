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
    private var headerTitle: String = ""
    
    @Injected(\.teamDetailsPresenter) private var presenter: TeamDetailsPresenter
    
    enum Section: Int, CaseIterable {
        case profileHeader = 0
        case seasonStats
        case keyPlayers
        case about
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupCollectionView()
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
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .profileHeader:
                return self?.createFullWidthSection(height: 240, hasHeader: false)
            case .seasonStats:
                return self?.createGridSection()
            case .keyPlayers:
                return self?.createHorizontalScrollSection()
            case .about:
                return self?.createFullWidthSection(height: 150, hasHeader: true)
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
        if hasHeader {
            section.boundarySupplementaryItems = [createSectionHeader()]
        }
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
    
    func displayTeamDetails(team: Team, stats: TeamSeasonStats?, players: [Player]) {
        self.team = team
        self.stats = stats
        self.players = players
        self.headerTitle = team.name
        
        DispatchQueue.main.async {
            self.globalHeader?.configure(title: self.headerTitle, country: "", showTabs: false, showBackButton: true, showHeader: true, showFavBtn: false)
            self.collectionView.reloadData()
        }
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
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
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard team != nil else { return 0 }
        switch Section(rawValue: section)! {
        case .profileHeader: return 1
        case .seasonStats: return 4
        case .keyPlayers: return players.count
        case .about: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .profileHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let t = team {
                cell.configure(imageUrl: t.logoUrl, title: t.name)
            }
            return cell
            
        case .seasonStats:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsGridCell", for: indexPath) as! statsGridCollectionViewCell
            let titles = ["Points", "Matches Played", "Goal Difference", "Wins"]
            let values = ["\(stats?.points ?? 0)", "\(stats?.matchesPlayed ?? 0)", "\(stats?.goalDifference ?? 0)", "\(stats?.wins ?? 0)"]
            cell.configure(title: titles[indexPath.item], value: values[indexPath.item], valueColor: indexPath.item == 0 ? .systemGreen : AppColor.textPrimary)
            return cell
            
        case .keyPlayers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeyPlayerCell", for: indexPath) as! KeyPlayerCell
            cell.configure(player: players[indexPath.item])
            return cell
            
        case .about:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AboutTeamCell", for: indexPath) as! AboutTeamCell
            cell.configure(text: team?.description ?? "No description available.")
            return cell
        }
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
        switch Section(rawValue: indexPath.section)! {
        case .seasonStats: header.titleLabel.text = "SEASON STATS"
        case .keyPlayers: header.titleLabel.text = "KEY PLAYERS"
        case .about: header.titleLabel.text = "ABOUT"
        default: header.titleLabel.text = ""
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Section(rawValue: indexPath.section) == .keyPlayers {
            presenter.didSelectPlayer(at: indexPath.item)
        }
    }
}

extension TeamDetailsViewController: LeagueDetailsHeaderDelegate {
    func didTapBackButton() {
        presenter.didTapBack()
    }
    func didSelectTab(index: Int) {}
    func didTapFavourite() {}
    func didTapThemeButton() {}
    func didSelectLanguage(_ code: String) {}
}
