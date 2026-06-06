import UIKit
import Factory

class PlayerDetailsViewController: UIViewController, PlayerProfileView {
    
    var collectionView: UICollectionView!
    var playerIdPassed: String = ""
    
    private var player: Player?
    private var stats: PlayerProfileStats?
    
    private weak var globalHeader: LeagueDetailsHeader?
    private var headerTitle: String = ""
    
    @Injected(\.playerDetailsPresenter) private var presenter: PlayerProfilePresenter
    
    enum Section: Int, CaseIterable {
        case profileHeader = 0
        case seasonStats
        case disciplinary
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgPrimary
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupCollectionView()
        presenter.attachView(self)
        presenter.loadPlayerData(playerId: playerIdPassed)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ProfileHeaderCell")
        collectionView.register(UINib(nibName: "statsGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "StatsGridCell")
        collectionView.register(SectionTitleHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        collectionView.register(UINib(nibName: "LeagueDetailsHeader", bundle: nil), forSupplementaryViewOfKind: "GlobalHeaderKind", withReuseIdentifier: "leagueDetailsHeader")
        
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .profileHeader:
                return self?.createFullWidthSection(height: 220, hasHeader: false)
            case .seasonStats, .disciplinary:
                return self?.createGridSection()
            }
        }
        layout.configuration = globalHeaderConfiguration()
        return layout
    }
    
    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "GlobalHeaderKind", alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
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
    
    func showLoading() {}
    func hideLoading() {}
    
    func displayPlayerProfile(player: Player, stats: PlayerProfileStats?) {
        self.player = player
        self.stats = stats
        self.headerTitle = player.name
        
        DispatchQueue.main.async {
            self.globalHeader?.configure(title: self.headerTitle, country: "", showTabs: false, showBackButton: true, showHeader: true, showFavBtn: false)
            self.collectionView.reloadData()
        }
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension PlayerDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard player != nil else { return 0 }
        switch Section(rawValue: section)! {
        case .profileHeader: return 1
        case .seasonStats: return 4
        case .disciplinary: return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .profileHeader:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHeaderCell", for: indexPath) as! ProfileHeaderCell
            if let p = player {
                cell.configure(imageUrl: p.imageUrl, title: p.name)
            }
            return cell
            
        case .seasonStats, .disciplinary:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatsGridCell", for: indexPath) as! statsGridCollectionViewCell
            if section == .seasonStats {
                let titles = ["Goals", "Assists", "Matches Played", "Total Cards"]
                let values = ["\(stats?.season.goals ?? 0)", "\(stats?.season.assists ?? 0)", "\(stats?.season.matchesPlayed ?? 0)", "\(stats?.season.totalCards ?? 0)"]
                cell.configure(title: titles[indexPath.item], value: values[indexPath.item], valueColor: indexPath.item == 0 ? .systemGreen : AppColor.textPrimary)
            } else {
                let titles = ["Yellow Cards", "Red Cards"]
                let values = ["\(stats?.disciplinary.yellowCards ?? 0)", "\(stats?.disciplinary.redCards ?? 0)"]
                cell.configure(title: titles[indexPath.item], value: values[indexPath.item], valueColor: indexPath.item == 0 ? .systemYellow : .systemRed)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == "GlobalHeaderKind" {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "leagueDetailsHeader", for: indexPath) as! LeagueDetailsHeader
            self.globalHeader = header
            header.configure(title: headerTitle, country: "", showTabs: false, showBackButton: true, showHeader: true, showFavBtn: false)
            header.delegate = self
            return header
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionTitleHeaderView
        switch Section(rawValue: indexPath.section)! {
        case .seasonStats: header.titleLabel.text = "2025/26 SEASON STATS"
        case .disciplinary: header.titleLabel.text = "DISCIPLINARY"
        default: header.titleLabel.text = ""
        }
        return header
    }
}

extension PlayerDetailsViewController: LeagueDetailsHeaderDelegate {
    func didTapBackButton() {
        presenter.didTapBack()
    }
    func didSelectTab(index: Int) {}
    func didTapFavourite() {}
    func didTapThemeButton() {}
    func didSelectLanguage(_ code: String) {}
}

class SectionTitleHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = AppFont.caption
        titleLabel.textColor = AppColor.textSecondary
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
