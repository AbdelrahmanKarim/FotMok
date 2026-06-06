//
//  LeagueTabManager.swift
//  FotMoc
//
//  Created by Alaa Ayman on 05/06/2026.
//
import Foundation
import UIKit
protocol LeagueTabManager {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func cell(for collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func getSectionFor(index : Int) -> NSCollectionLayoutSection
    func supplementaryView(for collectionView: UICollectionView, kind: String, at indexPath: IndexPath) -> UICollectionReusableView?
 
    func getSkeletonCellIdentifier(for section: Int) -> String
    func numberOfItemsInSectionSkeleton(section : Int)-> Int
    func getMatch(at indexPath: IndexPath) -> Match?
}
