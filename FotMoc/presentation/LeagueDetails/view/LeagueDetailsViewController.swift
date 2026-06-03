//
//  LeagueDetailsViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 21/05/2026.
//

import UIKit

class LeagueDetailsViewController: UIViewController , LeagueDetailsView{
    @IBOutlet weak var collectionView: UICollectionView!
    var currentTab: LeagueTab = .overview
    let overviewTab = OverviewTab()
    let tableTab = TableTab()
    let topScorer = TopScorersTab()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: true)
        collectionView.backgroundColor = AppColor.bgPrimary
   
        // Do any additional setup after loading the view.
        registerCells()
        registerHeaders()
   
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LeagueDetailsViewController : UICollectionViewDataSource , UICollectionViewDelegate {
    func getActiveTab() -> LeagueTabManager {
        switch currentTab {
        case .overview:
            return overviewTab
        case .table:
            return tableTab
        case .topScorers:
            return topScorer
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
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "leagueDetailsHeader",for: indexPath) as! LeagueDetailsHeader
                    header.configure(title: "League Details", country: "Egypt" , showTabs: true)

                    header.delegate = self

                    return header

                }
            if let customSupplementaryView = getActiveTab().supplementaryView(for: collectionView, kind: kind, at: indexPath) {
                return customSupplementaryView
            }
            
           
            return UICollectionReusableView()
        }
    
}



extension LeagueDetailsViewController: LeagueDetailsHeaderDelegate{
    func didTapBackButton() {
        
    }
    
    func didSelectTab(index: Int) {
        guard let selectedTab = LeagueTab(rawValue: index) else { return }
        self.currentTab = selectedTab
        collectionView.reloadData()
    }
}
protocol LeagueTabManager {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func getSectionFor(index : Int) -> NSCollectionLayoutSection
    func supplementaryView(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView?
}
