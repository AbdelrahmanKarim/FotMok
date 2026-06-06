//
//  LiveMatchesViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit
import Factory
import SkeletonView

class LiveMatchesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @Injected(\.liveMatchesPresenter) private var presenter: LiveMatchesPresenter

    private var matches: [Match] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = AppColor.bgPrimary
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.isSkeletonable = true
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: false)
        registerCells()
        registerHeaders()
        presenter.attachView(self)
        presenter.loadLiveMatches()
    }

    deinit { presenter.detachView() }

    private func registerCells() {
        collectionView.register(
            UINib(nibName: "LiveMatchesCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "liveMatchCell"
        )
        let emptyNib = UINib(nibName: "EmptyStateCollectionViewCell", bundle: nil)
        collectionView.register(emptyNib, forCellWithReuseIdentifier: "emptyState")
    }

    private func registerHeaders() {
        collectionView.register(
            UINib(nibName: "LeagueDetailsHeader", bundle: nil),
            forSupplementaryViewOfKind: "GlobalHeaderKind",
            withReuseIdentifier: "leagueDetailsHeader"
        )
    }
}

// MARK: - LiveMatchesView

extension LiveMatchesViewController: LiveMatchesView {

    func showLoading() {
        collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }

    func hideLoading(then completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            completion?()
        }
    }

    func displayMatches(_ matches: [Match]) {
        self.matches = matches
        collectionView.backgroundView = nil
        collectionView.reloadData()
    }

    func displayEmptyState() {
        self.matches = []
        let emptyCell = EmptyStateCollectionViewCell.loadFromNib()
        emptyCell.configure(
            message: NSLocalizedString("empty_no_live", comment: ""),
            iconName: "antenna.radiowaves.left.and.right.slash"
        )
        emptyCell.frame = collectionView.bounds
        collectionView.backgroundView = emptyCell
        collectionView.reloadData()
    }

    func displayError(message: String) {
        hideLoading(then: { self.displayEmptyState() })
    }
}

// MARK: - UICollectionView

extension LiveMatchesViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { matches.count }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "liveMatchCell", for: indexPath) as! LiveMatchesCollectionViewCell
        cell.configure(with: matches[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "leagueDetailsHeader",
            for: indexPath) as! LeagueDetailsHeader
        header.configure(
            title: NSLocalizedString("live_matches_title", comment: ""),
            country: "",
            showBackButton: false
        )
        header.delegate = self
        return header
    }

    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize, elementKind: "GlobalHeaderKind", alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
    }

    func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            self.setupLiveMatchesSection()
        }
        layout.configuration = globalHeaderConfiguration()
        return layout
    }

    private func setupLiveMatchesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(150)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
}

// MARK: - LeagueDetailsHeaderDelegate

extension LiveMatchesViewController: LeagueDetailsHeaderDelegate {
    func didSelectTab(index: Int) { }
    func didTapBackButton() { }
    func didTapThemeButton() { }
    func didSelectLanguage(_ code: String) { }
}

// MARK: - SkeletonView

extension LiveMatchesViewController: SkeletonCollectionViewDataSource {

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "liveMatchCell"
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView,
                                numberOfItemsInSection section: Int) -> Int { 4 }

    func numSections(in collectionSkeletonView: UICollectionView) -> Int { 1 }
}
