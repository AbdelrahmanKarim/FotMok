//
//  LeagueDetailsViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 21/05/2026.
//

import UIKit
import Factory
import SkeletonView

class LeagueDetailsViewController: UIViewController{
   
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sport: SportType!
    var currentTab: LeagueTab = .overview
    let overviewTab = OverviewTab()
    let tableTab = TableTab()
    let topScorersTab = TopScorersTab()
    private var leagueName: String = ""
    private var leagueCountry: String = ""
    private var activeLeagueId: String = ""

    // in viewDidLoad:
    
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
        
         activeLeagueId = Container.shared.currentSportProvider().selectedLeague
        print("Triggering content retrieval for ID: \(activeLeagueId)")
        presenter.loadLeagueDetails(leagueId: activeLeagueId)
        presenter.loadLeagueContent(leagueId: activeLeagueId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

  
    
    private func registerCells(){
        let upcomingEventNib = UINib(nibName: "UpcomingCollectionViewCell", bundle: nil)
            collectionView.register(upcomingEventNib,forCellWithReuseIdentifier: "upcomingEventsCell" )
        
        let latestEventNib = UINib(nibName: "LatestEventCollectionViewCell", bundle: nil)
            collectionView.register(latestEventNib,forCellWithReuseIdentifier: "latestEventCell" )
        let standingsNib = UINib(nibName: "StandingsCollectionViewCell", bundle: nil)
        collectionView.register(standingsNib,forCellWithReuseIdentifier: "standingsCell" )
        
        let topScorerNib  = UINib(nibName: "TopScorerCollectionViewCell", bundle: nil)
        collectionView.register(topScorerNib, forCellWithReuseIdentifier: "topScorerCell")
    
        let emptyStateNib = UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil)
                collectionView.register(emptyStateNib, forCellWithReuseIdentifier: "emptyState")
    }
    private func registerHeaders(){
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(globalHeaderNib,forSupplementaryViewOfKind: "GlobalHeaderKind",withReuseIdentifier: "leagueDetailsHeader")
        
        let headerNib = UINib(nibName: "CustomSectionHeader", bundle: nil)
            collectionView.register(headerNib,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: "customHeader")

       let tableHeaderNib = UINib(nibName: "StandingsHeaderCollectionReusableView", bundle: nil)
        collectionView.register(tableHeaderNib,forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: "standingsHeader")
        
        collectionView.register(LatestEventsFooter.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "latestEventsFooter")
    }
    deinit {
        presenter.detachView()
    }
    
    func onShowMoreTapped(){
        overviewTab.onShowMoreTapped = { [weak self] in
                self?.presenter.didTapShowMoreLatest()
            }
    }
    
}
extension LeagueDetailsViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    func getActiveTab() -> LeagueTabManager {
        switch currentTab {
        case .overview:
            return overviewTab
        case .table:
            return tableTab
        case .topScorers:
            return topScorersTab
        default:
            return overviewTab
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
         
                return self.getActiveTab().getSectionFor(index: index)
            }
            layout.configuration = globalHeaderConfiguration()
            return layout
        }
   
 

    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {

          let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .absolute(150))

          let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,elementKind: "GlobalHeaderKind",alignment: .top)

          let config = UICollectionViewCompositionalLayoutConfiguration()
         config.boundarySupplementaryItems = [globalHeader]

          return config

      }
   
    func collectionView(_ collectionView: UICollectionView,
                            viewForSupplementaryElementOfKind kind: String,
                            at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "GlobalHeaderKind" {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "leagueDetailsHeader", for: indexPath
            ) as! LeagueDetailsHeader
            header.configure(title: leagueName, country: leagueCountry, showTabs: true, showFavBtn: true)
            header.delegate = self
            return header
        }
            if let customSupplementaryView = getActiveTab().supplementaryView(for: collectionView, kind: kind, at: indexPath) {
                return customSupplementaryView
            }
            
            return UICollectionReusableView()
        }
    
}


extension LeagueDetailsViewController : LeagueDetailsView{
   
   
    func navigateToLatestMatches() {
        guard let latestMatchVC = storyboard?.instantiateViewController(withIdentifier: "latestMatchScreen") as? LatestEventsViewController else {return}
        navigationController?.pushViewController(latestMatchVC, animated: true)
    }
    func navigateBack() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
            }
        
    func showLoading() {
        collectionView.dataSource = self
        collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }
    
    func hideLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
    }
    
    func displayOverviewData(upcoming: [Match], latest: [Match] , teamsOrPlayers : [Any]) {
        print(" upcoming (\(upcoming.count)) and latest (\(latest.count)) records.")
    
        overviewTab.updateData(upcoming: upcoming, latest: latest , teamsOrPlayers: teamsOrPlayers)
        DispatchQueue.main.async {
                self.collectionView.reloadData()
                if upcoming.isEmpty && latest.isEmpty && teamsOrPlayers.isEmpty {
                    print("No data found for this league.")
                }
            }
       
    }
    func displayTableData(standings: [StandingRow]) {
        tableTab.updateData(standings: standings)
        DispatchQueue.main.async {
            guard self.currentTab == .table else { return }
            self.hideLoading()
            // Invalidate layout so section sizes recalculate correctly
            self.collectionView.setCollectionViewLayout(
                self.setUpCollectionViewLayout(), animated: false
            )
            self.collectionView.reloadData()
        }
    }

    func displayTopScorers(scorers: [TopScorer]) {
        topScorersTab.updateData(topScorers: scorers)
        DispatchQueue.main.async {
            guard self.currentTab == .topScorers else { return }
            self.hideLoading()
            self.collectionView.setCollectionViewLayout(
                self.setUpCollectionViewLayout(), animated: false
            )
            self.collectionView.reloadData()
        }
    }
    func displayError(message: String) {
        print(" received failure message -> [\(message)]")
    }
    func displayLeagueInfo(name: String, country: String) {
        leagueName = name
        leagueCountry = country
        
 
        let indexPath = IndexPath(item: 0, section: 0)
        if let header = collectionView.supplementaryView(
            forElementKind: "GlobalHeaderKind", at: indexPath
        ) as? LeagueDetailsHeader {
            header.configure(title: name, country: country, showTabs: true, showFavBtn: true)
        }
    }
}
extension LeagueDetailsViewController: LeagueDetailsHeaderDelegate{
    func didTapBackButton() {
        presenter.didTapBack()
    }
   
    func didSelectTab(index: Int) {
        guard let selectedTab = LeagueTab(rawValue: index) else { return }
        self.currentTab = selectedTab
       
        switch selectedTab {
        case .table:
            tableTab.isLoading = true
            collectionView.reloadData()
            collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
            showLoading()
            presenter.loadTableContent(leagueId: activeLeagueId)
        case .topScorers:
            topScorersTab.isLoading = true
            collectionView.reloadData()
            collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
            showLoading()
            presenter.loadTopScorers(leagueId: activeLeagueId)
        default:
            collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
            collectionView.reloadData()
        }
    }
}


extension LeagueDetailsViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return getActiveTab().getSkeletonCellIdentifier(for : indexPath.section)
    }
    

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getActiveTab().numberOfItemsInSectionSkeleton(section: section)
    }
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
         return getActiveTab().numberOfSections()
     }
    
}
