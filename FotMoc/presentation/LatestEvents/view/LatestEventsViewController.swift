//
//  LatestEventsViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//

import UIKit
import Factory
import SkeletonView

class LatestEventsViewController: UIViewController, LatestView {
    
    private var matches: [Match] = []
    
    @Injected(\.latestEventsPresenter) private var presenter: LatestPresenter
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var noInternetView: NoInternetOverlayView = {
        let v = NoInternetOverlayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        v.onRetry = { [weak self] in
            self?.presenter.retryLoading()
        }
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = AppColor.bgPrimary
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: true)
        registerCells()
        registerHeaders()
        collectionView.isSkeletonable = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupNoInternetConstraints()
        
        presenter.attachView(self)
        presenter.loadLatestMatches()
    }
    
    private func setupNoInternetConstraints() {
        view.addSubview(noInternetView)
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 100),
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func registerCells() {
        let latestEventNib = UINib(nibName: "LatestEventCollectionViewCell", bundle: nil)
        collectionView.register(latestEventNib, forCellWithReuseIdentifier: "latestEventCell")
    }
    
    func registerHeaders() {
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(globalHeaderNib, forSupplementaryViewOfKind: "GlobalHeaderKind", withReuseIdentifier: "leagueDetailsHeader")
    }
    
    deinit {
        presenter.detachView()
    }
    
    func showLoading() {
        collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }
    
    func hideLoading(then completion: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            completion?()
        }
    }
    
    func showNoInternet() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.noInternetView.isHidden = false
        }
    }
    
    func hideNoInternet() {
        DispatchQueue.main.async {
            self.collectionView.isHidden = false
            self.noInternetView.isHidden = true
        }
    }
    
    func displayEmptyState() {
        self.matches = []
        collectionView.backgroundView = nil
        let emptyCell = EmptyStateCollectionViewCell.loadFromNib()
        emptyCell.configure(message: NSLocalizedString("empty_no_latest", comment: ""))
        emptyCell.frame = collectionView.bounds
        collectionView.backgroundView = emptyCell
        collectionView.reloadData()
    }
    
    func displayMatches(_ matches: [Match]) {
        self.matches = matches
        collectionView.backgroundView = nil
        DispatchQueue.main.async { self.collectionView.reloadData() }
    }
    
    func displayError(message: String) {
        print("Error fetching latest events: \(message)")
        displayEmptyState()
    }
    
    func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LatestEventsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
        let match = matches[indexPath.item]
        cell.configure(with: match)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "leagueDetailsHeader", for: indexPath) as! LeagueDetailsHeader
        header.delegate = self
        header.configure(title: NSLocalizedString("latest_matches", comment: ""), country: NSLocalizedString("global", comment: ""))
       
        return header
    }
    
    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "GlobalHeaderKind", alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
    }
    
    func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { index, environment in
            return self.getSectionFor(index: index)
        }
        layout.configuration = globalHeaderConfiguration()
        return layout
    }
    
    func getSectionFor(index: Int) -> NSCollectionLayoutSection {
        return self.setupLatestEventSection()
    }
    
    private func setupLatestEventSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
}

extension LatestEventsViewController: LeagueDetailsHeaderDelegate {
    func didTapFavourite() {}
    func didSelectLanguage(_ code: String) {}
    func didTapThemeButton() {}
    func didTapBackButton() { presenter.didTapBack() }
    func didSelectTab(index: Int) {}
}

extension LatestEventsViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "latestEventCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int { 1 }
}
