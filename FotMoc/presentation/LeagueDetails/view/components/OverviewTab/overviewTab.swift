//
//  overviewTab.swift
//  FotMoc
//
//  Created by Alaa Ayman on 28/05/2026.
//
import UIKit
class OverviewTab: LeagueTabManager {
    
  
    let sectionHeaders: [Int: SectionHeader] = [
        0: SectionHeader(title: "Upcoming Events", iconName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90"),
        1: SectionHeader(title: "Latest Events", iconName: "trophy"),
        2: SectionHeader(title: "Teams", iconName: "person.2")
    ]
    

    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItems(in section: Int) -> Int {
        if section == 0 { return 5 }
        if section == 1 { return 2 }
        if section == 2 { return 10 }
        return 0
    }
    
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventsCell", for: indexPath) as! UpcomingCollectionViewCell
            cell.configure(homeTeam: "Al Ahly SC", awayTeam: "Zamalek SC", date: "May 24", time: "20:00")
            return cell
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamPlayerCell", for: indexPath) as! Teams_Players_Cell
            cell.configure(teamName: "Al Ahly SC")
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    

    func getSectionFor(index : Int) -> NSCollectionLayoutSection{
        if index == 0{ return self.setupUpcomingEventsSection()}
        if index == 1 {return self.setupLatestSection()}
        if index == 2 {return self.setupTeamOrPlayerSection()}
        else {return self.setupUpcomingEventsSection()}
    }
    
    func supplementaryView(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
            
          
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "customHeader",
                    for: indexPath) as! CustomSectionHeader
                
                if let info = sectionHeaders[indexPath.section] {
                    header.configure(title: info.title, iconName: info.iconName)
                }
                return header
            }
            
        
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "latestEventsFooter",
                    for: indexPath
                )
                return footer
            }
            
            return nil
        }
    private func cardSection(
            groupWidth: NSCollectionLayoutDimension = .fractionalWidth(1),
            groupHeight: NSCollectionLayoutDimension,
            scrolling: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
            contentInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10),
            interGroupSpacing: CGFloat = 0,
            supplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem]
        ) -> NSCollectionLayoutSection {

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

            let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = scrolling
            
           
            section.contentInsets = contentInsets
            
            section.interGroupSpacing = interGroupSpacing
            section.boundarySupplementaryItems = supplementaryItems
            return section
        }
    func setupUpcomingEventsSection() -> NSCollectionLayoutSection {
        return cardSection(
            groupWidth: .fractionalWidth(0.75),
            groupHeight: .absolute(200),
            scrolling: .continuous,
            contentInsets: NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0),
            supplementaryItems: [sectionHeaderConfiguration()]
        )
    }

    func setupLatestSection() -> NSCollectionLayoutSection {
        return cardSection(
            groupHeight: .absolute(150),
            interGroupSpacing: 10,
            supplementaryItems: [sectionHeaderConfiguration(), sectionFooterConfiguration()]
        )
    }

    func setupTeamOrPlayerSection() -> NSCollectionLayoutSection {
        return cardSection(
            groupWidth: .fractionalWidth(0.35),
            groupHeight: .absolute(150),
            scrolling: .continuous,
            interGroupSpacing: 10,
            supplementaryItems: [sectionHeaderConfiguration()]
        )
    }
    private func sectionHeaderConfiguration() -> NSCollectionLayoutBoundarySupplementaryItem {
         let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(44))
        
        return NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: size,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
     }
    private func sectionFooterConfiguration()->NSCollectionLayoutBoundarySupplementaryItem{
        let footerSize = NSCollectionLayoutSize(widthDimension: .estimated(100),heightDimension: .absolute(44))

            return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,elementKind: UICollectionView.elementKindSectionFooter,alignment: .bottomTrailing)
    }
}
  
   

