//
//  HeadToHeadViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit


class HeadToHeadViewController: UIViewController , HeadToHeadView {

    
    @IBOutlet weak var collectionView: UICollectionView!
    let sectionHeaders: [Int: SectionHeader] = [
        0: SectionHeader(title: "Upcoming Events",    iconName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90"),
        1: SectionHeader(title: "Recent Forms",       iconName: "chart.xyaxis.line"),
        2: SectionHeader(title: "Recent Matches",     iconName: "sportscourt"),
        3: SectionHeader(title: "Overall H2H Record", iconName: "chart.pie")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: true)
        
        collectionView.backgroundColor = AppColor.bgPrimary
        registerHeaders()
        registerCells()
        

        // Do any additional setup after loading the view.
    }
    private func registerCells(){
        let upcomingEventNib = UINib(nibName: "UpcomingCollectionViewCell", bundle: nil)
            collectionView.register(upcomingEventNib,forCellWithReuseIdentifier: "upcomingEventsCell" )
        
        let recentFormNib = UINib(nibName: "RecentFormCollectionViewCell", bundle: nil)
        collectionView.register(recentFormNib,forCellWithReuseIdentifier: "recentFormCell" )
        
        let previousMatchNib = UINib(nibName: "LatestEventCollectionViewCell", bundle: nil)
        collectionView.register(previousMatchNib, forCellWithReuseIdentifier: "latestEventCell")
        
        let overallH2HNib = UINib(nibName: "OverallH2HCollectionViewCell", bundle: nil)
        collectionView.register(overallH2HNib,forCellWithReuseIdentifier: "overallH2HCell" )
    }
    private func registerHeaders(){
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(globalHeaderNib,forSupplementaryViewOfKind: "GlobalHeaderKind",withReuseIdentifier: "leagueDetailsHeader")
        
        let headerNib = UINib(nibName: "CustomSectionHeader", bundle: nil)
        collectionView.register(headerNib,forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader,withReuseIdentifier: "customHeader")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

   
    
    
}
extension HeadToHeadViewController : UICollectionViewDelegate , UICollectionViewDataSource{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
         switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 5
        case 3: return 1
        default: return 0
        }
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section
        {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventsCell", for: indexPath) as! UpcomingCollectionViewCell
            cell.configure(homeTeam: "Al Ahly SC",awayTeam: "Zamalek SC",date: "May 24",time: "20:00")
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recentFormCell", for: indexPath) as! RecentFormCollectionViewCell
            let ahlyResults = ["W", "W", "D", "W", "L"]
            let zamalekResults = ["W", "D", "W", "W", "W"]
                    
          cell.configure(firstTeam: "Al Ahly SC",secondTeam: "Zamalek SC",teamOneResults: ahlyResults,teamTwoResults: zamalekResults)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
            
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "overallH2HCell", for: indexPath) as! OverallH2HCollectionViewCell
            cell.configure(homeWins: "2", draws: "1", awayWins: "2")
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventsCell", for: indexPath) as! UpcomingCollectionViewCell
            return cell
        }
        
    }
    
    func setUpCollectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout{index , environment in
            return self.getSectionFor(index : index)
        }

            layout.configuration = globalHeaderConfiguration()
        return layout
    }
    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
         let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .absolute(100))
         let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: headerSize,elementKind: "GlobalHeaderKind",alignment: .top)
         let config = UICollectionViewCompositionalLayoutConfiguration()
         config.boundarySupplementaryItems = [globalHeader]
         return config
     }
    private func sectionHeaderConfiguration() -> NSCollectionLayoutBoundarySupplementaryItem {
         let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(44))
         return NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: size,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
     }
    func getSectionFor(index : Int) -> NSCollectionLayoutSection{
        switch index {
          case 0: return cardSection(height: 200)
          case 1: return cardSection(height: 200)
          case 2: return cardSection(height: 150, interGroupSpacing: 10)
          case 3: return cardSection(height: 200)
          default: return cardSection(height: 200)
          }
        
    }


     func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == "GlobalHeaderKind" {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "leagueDetailsHeader",
                for: indexPath) as! LeagueDetailsHeader
            header.configure(title: "Head to Head", country: "")
            return header
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "customHeader",
            for: indexPath) as! CustomSectionHeader

        if let info = sectionHeaders[indexPath.section] {
            header.configure(title: info.title, iconName: info.iconName)
        }

        return header
    }
   
    private  func cardSection(height: CGFloat, interGroupSpacing: CGFloat = 0) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = [sectionHeaderConfiguration()]
        return section
    }
}
