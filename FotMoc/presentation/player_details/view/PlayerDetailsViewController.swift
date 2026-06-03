//
//  PlayerDetailsViewController.swift
//  FotMoc
//
//  Created by abdelrahman karim on 31/05/2026.
//

import UIKit

class PlayerDetailsViewController: UIViewController , PlayerDetailsView{
    
    var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable {
        case profileHeader = 0
        case seasonStats
        case disciplinary
        case performanceMetrics
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgPrimary
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        
        collectionView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ProfileHeaderCell")
        collectionView.register(UINib(nibName: "statsGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatsGridCell")
        collectionView.register(UINib(nibName: "PerformanceMetricsCell", bundle: nil), forCellWithReuseIdentifier: "PerformanceCell")
        
        collectionView.register(SectionTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            
            switch section {
            case .profileHeader:
                return self?.createFullWidthSection(height: 220, hasHeader: false)
            case .seasonStats, .disciplinary:
                return self?.createGridSection()
            case .performanceMetrics:
                return self?.createFullWidthSection(height: 200, hasHeader: true)
            }
        }
    }
    
    private func createFullWidthSection(height: CGFloat, hasHeader: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 24, trailing: 16)
        
        if hasHeader {
            section.boundarySupplementaryItems = [createSectionHeader()]
        }
        return section
    }
    
    private func createGridSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 10, bottom: 24, trailing: 10)
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
        return NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

extension PlayerDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .profileHeader: return 1
        case .seasonStats: return 4
        case .disciplinary: return 2
        case .performanceMetrics: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .profileHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath)
            return cell
            
        case .seasonStats, .disciplinary:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsGridCell", for: indexPath) as! statsGridCollectionViewCell
            
            if section == .seasonStats {
                let titles = ["Goals", "Assists", "Matches Played", "Total Cards"]
                let values = ["18", "7", "22", "2"]
                cell.statTitleLabel.text = titles[indexPath.item]
                cell.statValueLabel.text = values[indexPath.item]
            } else {
                let titles = ["Yellow Cards", "Red Cards"]
                let values = ["2", "0"]
                cell.statTitleLabel.text = titles[indexPath.item]
                cell.statValueLabel.text = values[indexPath.item]
            }
            return cell
            
        case .performanceMetrics:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PerformanceCell", for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionTitleHeaderView
        
        switch Section(rawValue: indexPath.section)! {
        case .seasonStats: header.titleLabel.text = "2025/26 SEASON STATS"
        case .disciplinary: header.titleLabel.text = "DISCIPLINARY"
        case .performanceMetrics: header.titleLabel.text = "PERFORMANCE METRICS"
        default: header.titleLabel.text = ""
        }
        return header
    }
}

class SectionTitleHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AppFont.caption
        titleLabel.textColor = AppColor.textTertiary
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
