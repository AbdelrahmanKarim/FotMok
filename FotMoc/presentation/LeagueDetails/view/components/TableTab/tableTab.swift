//
//  TableTab.swift
//  FotMoc
//
//  Created by Alaa Ayman on 28/05/2026.
//

import UIKit
import SkeletonView
import Kingfisher

class TableTab: LeagueTabManager {
    
    private var standings: [StandingRow] = []
    var isLoading: Bool = true
    
    func updateData(standings: [StandingRow]) {
        self.standings = standings
        isLoading = false
    }
    
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        if isLoading { return 0 }
        return standings.isEmpty ? 1 : standings.count
    }
    
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        
        if standings.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
            cell.configure(message: "No standings available for this league.", iconName: "list.number")
            return cell
        }
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standingsCell", for: indexPath) as! StandingsCollectionViewCell
        let row = standings[indexPath.item]
        
        
        let teamName = extractName(from: row.competitor)
        
        let logoUrl  = extractLogoUrl(from: row.competitor)
        
        var draws = 0
        var goalDiff = 0
        var goalsFor = 0
        
        
        switch row.sportMetrics {
        case .football(let d, let gd, let gf, _):
            draws = d
            goalDiff = gd
            goalsFor = gf
        default:
            break
        }
        
        cell.configure(
            rank: "\(row.rank)",
            teamName: teamName,
            logoUrl:  logoUrl,
            PG: row.matchesPlayed,
            W: row.wins,
            D: draws,
            L: row.losses,
            goals: goalsFor,
            GD: goalDiff,
            PTS: row.points ?? 0
        )
        
        
        
        return cell
    }
    
    
    func getSkeletonCellIdentifier(for section: Int) -> String {
        return "standingsCell"
    }
    
    func numberOfItemsInSectionSkeleton(section: Int) -> Int {
        return 5
    }
    
    
    func getSectionFor(index: Int) -> NSCollectionLayoutSection {
        return self.setupTableSection(isEmpty: standings.isEmpty)
    }
    
    func supplementaryView(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "standingsHeader",
                for: indexPath) as! StandingsHeaderCollectionReusableView
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
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrolling
        section.contentInsets = contentInsets
        section.interGroupSpacing = interGroupSpacing
        section.boundarySupplementaryItems = supplementaryItems
        return section
    }
    
    func setupTableSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        return cardSection(
            
            groupHeight: isEmpty ? .absolute(200) : .absolute(80),
            interGroupSpacing: 0,
            supplementaryItems: [sectionHeaderConfiguration()]
        )
    }
    
    private func sectionHeaderConfiguration() -> NSCollectionLayoutBoundarySupplementaryItem {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(44))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    func getMatch(at indexPath: IndexPath) -> Match? { return nil }
    
    private func extractName(from competitor: Competitor) -> String {
        switch competitor {
        case .team(let team): return team.name
        case .player(let player): return player.name
        }
    }
    
    private func extractLogoUrl(from competitor: Competitor) -> URL? {
        switch competitor {
        case .team(let team):     return team.logoUrl
        case .player(let player): return player.imageUrl
        }
    }
}
