//
//  tableTab.swift
//  FotMoc
//
//  Created by Alaa Ayman on 28/05/2026.
//

import UIKit
class TableTab: LeagueTabManager {
    
  
    

    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        if section == 0 { return 5 }
     
  
        return 0
    }
    
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
      
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "standingsCell", for: indexPath) as! StandingsCollectionViewCell
            cell.configure(rank: "1", teamName: "AL Ahly SC", PG: 12, W: 7, D: 2, L: 9, goals: 5, GD:4, PTS:40 )
            return cell
     
      
        
    }
    

    func getSectionFor(index : Int) -> NSCollectionLayoutSection{
         return self.setupTableSection()
      
     
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
    
  

    func setupTableSection() -> NSCollectionLayoutSection {
        return cardSection(
            groupHeight: .absolute(80),
            interGroupSpacing: 0,
            supplementaryItems: [sectionHeaderConfiguration()]
        )
    }

 
    private func sectionHeaderConfiguration() -> NSCollectionLayoutBoundarySupplementaryItem {
         let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(44))
         return NSCollectionLayoutBoundarySupplementaryItem(
             layoutSize: size,elementKind: UICollectionView.elementKindSectionHeader,alignment: .top)
     }

}
  
   
