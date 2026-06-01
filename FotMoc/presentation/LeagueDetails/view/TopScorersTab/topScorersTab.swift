//
//  topScorersTab.swift
//  FotMoc
//
//  Created by Alaa Ayman on 29/05/2026.
//

import Foundation
import UIKit
class TopScorersTab : LeagueTabManager {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return 10
    }
    
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topScorerCell", for: indexPath) as! TopScorerCollectionViewCell
        return cell
    }
    
    func getSectionFor(index: Int) -> NSCollectionLayoutSection {
         return self.setupTopScorersSection()
      
    }
    
    func supplementaryView(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }
  
    private func setupTopScorersSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 10
        section.contentInsets =  NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
       
   
        return section
    }
    
  



}
