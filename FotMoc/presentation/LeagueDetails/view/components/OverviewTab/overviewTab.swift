//
//  overviewTab.swift
//  FotMoc
//
//  Created by Alaa Ayman on 28/05/2026.
//

import UIKit
import SkeletonView

class OverviewTab: LeagueTabManager {
   
    
    private var upcomingMatches: [Match] = []
    private var latestMatches: [Match] = []
    private var teamsOrPlayers: [Any] = []
    var onShowMoreTapped: (() -> Void)?
    
    func updateData(upcoming: [Match], latest: [Match], teamsOrPlayers : [Any]) {
        self.upcomingMatches = upcoming
        self.latestMatches = latest
        self.teamsOrPlayers = teamsOrPlayers
        
    }
    func getMatch(at indexPath: IndexPath) -> Match? {
        switch indexPath.section {
        case 0:
            guard !upcomingMatches.isEmpty, indexPath.item < upcomingMatches.count else { return nil }
            return upcomingMatches[indexPath.item]
        case 1:
            guard !latestMatches.isEmpty, indexPath.item < latestMatches.count else { return nil }
            return latestMatches[indexPath.item]
        default:
            return nil  // section 2 is teams/players, no match to return
        }
    }
    let sectionHeaders: [Int: SectionHeader] = [
        0: SectionHeader(title: NSLocalizedString("upcoming_title", comment: ""), iconName: "clock.arrow.trianglehead.2.counterclockwise.rotate.90"),
        1: SectionHeader(title: NSLocalizedString("latest_title", comment: ""),   iconName: "trophy"),
        2: SectionHeader(title: NSLocalizedString("teams_title", comment: ""),    iconName: "person.2")
    ]

    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItems(in section: Int) -> Int {
        if section == 0 {
            return upcomingMatches.isEmpty ? 1 : upcomingMatches.count
        }
        if section == 1 {
            return latestMatches.isEmpty ? 1 : min(latestMatches.count, 3)
        }
        if section == 2 {
            return teamsOrPlayers.isEmpty ? 1 : teamsOrPlayers.count
        }
        return 0
    }
    
     func getSkeletonCellIdentifier(for section: Int) -> String {
        switch section {
        case 0: return "upcomingEventsCell"
        case 1: return "latestEventCell"
        case 2: return "teamPlayerCell"
        default: return "upcomingEventsCell"
        }
    }
    
    func numberOfItemsInSectionSkeleton(section: Int) -> Int {
        switch section {
        case 0: return 1 
        case 1: return 3
        case 2: return 4
        default: return 3
        }
    }
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if upcomingMatches.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
                
                cell.configure( message: NSLocalizedString("empty_no_upcoming", comment: ""), iconName: "calendar.badge.minus")
               
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingEventsCell", for: indexPath) as! UpcomingCollectionViewCell
            cell.configure(with: upcomingMatches[indexPath.item])
            return cell
                
        case 1:
            if latestMatches.isEmpty {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
                cell.configure( message: NSLocalizedString("empty_no_latest", comment: ""), iconName: "sportscourt")
            
                return cell
            }
                
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
            cell.configure(with: latestMatches[indexPath.item])
            return cell
                
        case 2:
            if teamsOrPlayers.isEmpty {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
                cell.configure( message: NSLocalizedString("empty_no_result", comment: ""), iconName: "calendar.badge.minus")
                        cell.configure(message: "No teams/players found.", iconName: "person.2.slash")
                        return cell
                    }
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamPlayerCell", for: indexPath) as! Teams_Players_Cell
                   
                    if indexPath.item < teamsOrPlayers.count {
                        let item = teamsOrPlayers[indexPath.item]
                        cell.configure(with: item)
                    }
                    return cell
                    
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    

    func getSectionFor(index : Int) -> NSCollectionLayoutSection{
        if index == 0 { return self.setupUpcomingEventsSection(isEmpty: upcomingMatches.isEmpty) }
        if index == 1 { return self.setupLatestSection() }
        if index == 2 { return self.setupTeamOrPlayerSection() }
        else { return self.setupUpcomingEventsSection(isEmpty: false) }
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
            ) as! LatestEventsFooter
            
            footer.showMoreAction = { [weak self] in
                self?.onShowMoreTapped?()
            }
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
    
   
    func setupUpcomingEventsSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        return cardSection(
            groupWidth: isEmpty ? .fractionalWidth(1.0) : .fractionalWidth(0.75),
            groupHeight: .absolute(200),
            scrolling: isEmpty ? .none : .continuous,
            contentInsets: NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0),
            supplementaryItems: [sectionHeaderConfiguration()]
        )
    }

    func setupLatestSection() -> NSCollectionLayoutSection {
        return cardSection(
            groupWidth: .fractionalWidth(1.0),
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
         let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        
        return NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
     }
    
    private func sectionFooterConfiguration() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .absolute(44))

        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottomTrailing)
    }
}
