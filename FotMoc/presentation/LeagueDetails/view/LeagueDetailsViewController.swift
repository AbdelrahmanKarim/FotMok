import UIKit
import Factory
import SkeletonView
import Network
import Kingfisher

class LeagueDetailsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sport: SportType!
    var leagueIdPassed: String = ""
    var currentTab: LeagueTab = .overview
    let overviewTab = OverviewTab()
    let tableTab = TableTab()
    let topScorersTab = TopScorersTab()
    private var leagueName: String = ""
    private var leagueCountry: String = ""
    private var activeLeagueId: String = ""
    private var isLeagueFavourite: Bool = false

    private lazy var noInternetView: NoInternetOverlayView = {
        let v = NoInternetOverlayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        v.onRetry = { [weak self] in
            self?.presenter.retryLoading()
        }
        return v
    }()

    private weak var globalHeader: LeagueDetailsHeader?

    @Injected(\.leagueDetailsPresenter) private var presenter: LeagueDetailsPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.contentInsetAdjustmentBehavior = .never
        presenter.attachView(self)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: true)
        collectionView.backgroundColor = AppColor.bgPrimary
        collectionView.isSkeletonable = true
        registerCells()
        registerHeaders()
        onShowMoreTapped()
        
        activeLeagueId = leagueIdPassed
        presenter.loadLeagueDetails(leagueId: activeLeagueId)
        presenter.loadLeagueContent(leagueId: activeLeagueId)
        
        view.addSubview(noInternetView)
        NSLayoutConstraint.activate([
             noInternetView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 150),
             noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func registerCells() {
        let upcomingEventNib = UINib(nibName: "UpcomingCollectionViewCell", bundle: nil)
        collectionView.register(upcomingEventNib, forCellWithReuseIdentifier: "upcomingEventsCell")
        
        let latestEventNib = UINib(nibName: "LatestEventCollectionViewCell", bundle: nil)
        collectionView.register(latestEventNib, forCellWithReuseIdentifier: "latestEventCell")
        
        let standingsNib = UINib(nibName: "StandingsCollectionViewCell", bundle: nil)
        collectionView.register(standingsNib, forCellWithReuseIdentifier: "standingsCell")
        
        let topScorerNib = UINib(nibName: "TopScorerCollectionViewCell", bundle: nil)
        collectionView.register(topScorerNib, forCellWithReuseIdentifier: "topScorerCell")
    
        let emptyStateNib = UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil)
        collectionView.register(emptyStateNib, forCellWithReuseIdentifier: "emptyState")
    }
    
    private func registerHeaders() {
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(globalHeaderNib, forSupplementaryViewOfKind: "GlobalHeaderKind", withReuseIdentifier: "leagueDetailsHeader")
        
        let headerNib = UINib(nibName: "CustomSectionHeader", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "customHeader")

        let tableHeaderNib = UINib(nibName: "StandingsHeaderCollectionReusableView", bundle: nil)
        collectionView.register(tableHeaderNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "standingsHeader")
        
        collectionView.register(LatestEventsFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "latestEventsFooter")
    }
    
    deinit {
        presenter.detachView()
    }
    
    func onShowMoreTapped() {
        overviewTab.onShowMoreTapped = { [weak self] in
            self?.presenter.didTapShowMoreLatest()
        }
    }
    
    func navigateToTeamDetails(teamId: String, leagueId: String) {
        guard let teamVC = storyboard?.instantiateViewController(withIdentifier: "teamDetailsScreen") as? TeamDetailsViewController else { return }
        teamVC.teamIdPassed = teamId
        teamVC.leagueIdPassed = leagueId
        navigationController?.pushViewController(teamVC, animated: true)
    }
        
    func navigateToPlayerProfile(playerId: String) {
        guard let playerVC = storyboard?.instantiateViewController(withIdentifier: "playerDetailsScreen") as? PlayerDetailsViewController else { return }
        playerVC.playerIdPassed = playerId
        navigationController?.pushViewController(playerVC, animated: true)
    }
}

extension LeagueDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func getActiveTab() -> LeagueTabManager {
        switch currentTab {
        case .overview:  return overviewTab
        case .table:     return tableTab
        case .topScorers: return topScorersTab
        default:         return overviewTab
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return getActiveTab().numberOfSections()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getActiveTab().numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return getActiveTab().cell(for: collectionView, at: indexPath)
    }
  
    func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment in
            // Delegate layout sizing strictly to the tabs so SkeletonView functions properly
            return self.getActiveTab().getSectionFor(index: index)
        }
        layout.configuration = globalHeaderConfiguration()
        return layout
    }
   
    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "GlobalHeaderKind", alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "GlobalHeaderKind" {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "leagueDetailsHeader", for: indexPath
            ) as! LeagueDetailsHeader
            self.globalHeader = header
            header.updateFavouriteState(isFavourite: self.isLeagueFavourite)
            header.configure(title: leagueName, country: leagueCountry, showTabs: true, showFavBtn: true, showActionBtnStackView: true)
            header.delegate = self
            return header
        }
        
        if let customSupplementaryView = getActiveTab().supplementaryView(for: collectionView, kind: kind, at: indexPath) {
            if currentTab == .overview && indexPath.section == 2 && kind == UICollectionView.elementKindSectionHeader {
                if sport == .tennis {
                    for subview in customSupplementaryView.subviews {
                        if let label = subview as? UILabel {
                            label.text = "PLAYERS"
                        } else {
                            for deeper in subview.subviews {
                                if let label = deeper as? UILabel {
                                    label.text = "PLAYERS"
                                }
                            }
                        }
                    }
                }
            }
            return customSupplementaryView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = getActiveTab().numberOfItems(in: indexPath.section)
        if count == 0 { return }
        
        switch currentTab {
        case .overview:
            if let match = getActiveTab().getMatch(at: indexPath) {
                presenter.didSelectMatch(match, leagueId: activeLeagueId)
            } else if indexPath.section == 2 {
                if indexPath.item < overviewTab.teamsOrPlayers.count {
                    let item = overviewTab.teamsOrPlayers[indexPath.item]
                    if let team = item as? Team {
                        presenter.didSelectTeam(teamId: team.id)
                    } else if let player = item as? Player {
                        presenter.didSelectPlayer(playerId: player.id)
                    }
                }
            }
        case .topScorers:
            if indexPath.item < topScorersTab.topScorers.count {
                let scorer = topScorersTab.topScorers[indexPath.item]
                presenter.didSelectPlayer(playerId: scorer.player.id)
            }
        case .table:
                    if indexPath.item < tableTab.standings.count {
                        let standing = tableTab.standings[indexPath.item]
                        switch standing.competitor {
                        case .team(let team):
                            presenter.didSelectTeam(teamId: team.id)
                        case .player(let player):
                            presenter.didSelectPlayer(playerId: player.id)
                        }
                    }
        }
    }
    
}

extension LeagueDetailsViewController: LeagueDetailsView {
  
    func navigateToLatestMatches() {
        guard let latestMatchVC = storyboard?.instantiateViewController(withIdentifier: "latestMatchScreen") as? LatestEventsViewController else { return }
        latestMatchVC.leagueIdPassed = self.activeLeagueId
        navigationController?.pushViewController(latestMatchVC, animated: true)
    }
    
    func navigateBack() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateFavouriteIcon(isFavourite: Bool) {
        self.isLeagueFavourite = isFavourite
        DispatchQueue.main.async {
            self.globalHeader?.updateFavouriteState(isFavourite: isFavourite)
        }
    }
    
    func displayLeagueInfo(name: String, country: String) {
        leagueName = name
        leagueCountry = country
        
        DispatchQueue.main.async {
            self.globalHeader?.configure(title: name, country: country, showTabs: true, showFavBtn: true)
            self.globalHeader?.updateFavouriteState(isFavourite: self.isLeagueFavourite)
        }
    }
    
    func navigateToH2H(teamId1: String, teamId2: String, leagueId: String, title: String) {
        guard let h2hVC = storyboard?.instantiateViewController(
            withIdentifier: "headToHeadScreen") as? HeadToHeadViewController else { return }
        h2hVC.teamId1     = teamId1
        h2hVC.teamId2     = teamId2
        h2hVC.leagueId    = leagueId
        h2hVC.headerTitle = title
        navigationController?.pushViewController(h2hVC, animated: true)
    }
    
    func showLoading() {
        collectionView.alpha = 0
        let gradient = SkeletonGradient(baseColor: AppColor.bgSurface3)
        collectionView.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .none)
        collectionView.layoutIfNeeded()
        DispatchQueue.main.async {
            self.collectionView.alpha = 1
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.collectionView.setCollectionViewLayout(
                self.setUpCollectionViewLayout(), animated: false
            )
            self.collectionView.hideSkeleton(reloadDataAfter: true,
                                             transition: .crossDissolve(0.25))
        }
    }
    
    func displayOverviewData(upcoming: [Match], latest: [Match], teamsOrPlayers: [Any]) {
        overviewTab.updateData(upcoming: upcoming, latest: latest, teamsOrPlayers: teamsOrPlayers)
    }
 
    
    func displayTopScorers(scorers: [TopScorer]) {
        topScorersTab.updateData(topScorers: scorers)
        DispatchQueue.main.async {
            guard self.currentTab == .topScorers else {return}
           
            self.hideLoading()
        }
    }
    func displayTableData(standings: [StandingRow]) {
            tableTab.updateData(standings: standings)
            DispatchQueue.main.async {
                guard self.currentTab == .table else { return }
                
          
                self.hideLoading()
                
             
            }
        }
        
   
    func displayError(message: String) {
    }
    
    func showNoInternet() {
        DispatchQueue.main.async {
            self.collectionView.hideSkeleton()
            self.noInternetView.isHidden = false
        }
    }

    func hideNoInternet() {
        DispatchQueue.main.async {
            self.noInternetView.isHidden = true
        }
    }
}

extension LeagueDetailsViewController: LeagueDetailsHeaderDelegate {
    
    func didSelectLanguage(_ code: String) {}
    func didTapThemeButton() {}
    
    func didTapBackButton() {
        presenter.didTapBack()
    }
    
    func didTapFavourite() {
        presenter.toggleFavourite()
    }
    
    func didSelectTab(index: Int) {
        guard let selectedTab = LeagueTab(rawValue: index) else { return }
        self.currentTab = selectedTab
        
        switch selectedTab {
        case .topScorers:
            if topScorersTab.topScorers.isEmpty {
                topScorersTab.isLoading = true
                collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
                
                collectionView.reloadData()
                collectionView.layoutIfNeeded()
                
                
                showLoading()
                presenter.loadTopScorers(leagueId: activeLeagueId)
            } else {
                collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
                collectionView.reloadData()
            }
            
        case .table:
            if tableTab.standings.isEmpty {
                tableTab.isLoading = true
                collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
                
                collectionView.reloadData()
                collectionView.layoutIfNeeded()
                
                showLoading()
                presenter.loadTableContent(leagueId: activeLeagueId)
            } else {
                collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
                collectionView.reloadData()
            }
        default:
            collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
            collectionView.reloadData()
        }
    }}

extension LeagueDetailsViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return getActiveTab().getSkeletonCellIdentifier(for: indexPath.section)
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getActiveTab().numberOfItemsInSectionSkeleton(section: section)
    }
   
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
         return getActiveTab().numberOfSections()
     }
}
