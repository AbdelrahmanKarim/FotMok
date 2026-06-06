//
//  topScorersTab.swift
//  FotMoc
//
//  Created by Alaa Ayman on 29/05/2026.
//
import UIKit
import Foundation
class TopScorersTab: LeagueTabManager {
    
    private var topScorers: [TopScorer] = []
    var isLoading: Bool = true

    func updateData(topScorers: [TopScorer]) {
        self.topScorers = topScorers
        isLoading = false
    }

    func numberOfSections() -> Int { return 1 }

    func numberOfItems(in section: Int) -> Int {
        if isLoading { return 0 }
        return topScorers.isEmpty ? 1 : topScorers.count
    }

    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        if topScorers.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emptyState", for: indexPath) as! EmptyStateCollectionViewCell
            cell.configure(message: "No top scorers available.", iconName: "soccerball")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topScorerCell", for: indexPath) as! TopScorerCollectionViewCell
        let scorer = topScorers[indexPath.item]
        cell.configure(
            rank: scorer.rank,
            name: scorer.player.name,
            teamName: scorer.teamName,
            goals: scorer.goals,
            playerImageURL: scorer.player.imageUrl
        )
        return cell
    }

    func getSectionFor(index: Int) -> NSCollectionLayoutSection {
        return setupTopScorersSection(isEmpty: topScorers.isEmpty)
    }

    func getSkeletonCellIdentifier(for section: Int) -> String { return "topScorerCell" }
    func numberOfItemsInSectionSkeleton(section: Int) -> Int { return 5 }

    func supplementaryView(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        return nil
    }

    func getMatch(at indexPath: IndexPath) -> Match? { return nil }

    private func setupTopScorersSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: isEmpty ? .absolute(200) : .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
}
