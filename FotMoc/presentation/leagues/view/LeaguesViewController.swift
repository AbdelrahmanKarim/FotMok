import UIKit
import SkeletonView
import RxSwift
import RxCocoa
import Factory

class LeaguesViewController: UIViewController, UITableViewDelegate,SkeletonTableViewDataSource ,UITableViewDataSource,UISearchBarDelegate, LeaguesView {
   
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @Injected(\.leaguesPresenter) private var presenter: LeaguesPresenter
    private let disposeBag = DisposeBag()
    
    private let noResultsLabel = UILabel()
    private let noInternetLabel = UILabel()
    
    private lazy var noInternetView: NoInternetOverlayView = {
        let v = NoInternetOverlayView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isHidden = true
        v.onRetry = { [weak self] in
            self?.presenter.retryLoading()
        }
        return v
    }()
    private var globalHeader: LeagueDetailsHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupUI()
        setupEmptyStates()
        setupSearchBinding()
        
        tableView.dataSource = self
        tableView.delegate = self
        presenter.attachView(self)
        presenter.viewDidLoad()
        view.addSubview(noInternetView)
        NSLayoutConstraint.activate([
            noInternetView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0), // 150pt 
            noInternetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noInternetView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func exploreLiveBtn(_ sender: Any) {
        guard let liveMatchesVC = storyboard?.instantiateViewController(withIdentifier: "liveMatchesScreen") else { return }
        navigationController?.pushViewController(liveMatchesVC, animated: true)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "leagueCell"
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgPrimary
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "leagueCell")
        
        if let header = Bundle.main.loadNibNamed("LeagueDetailsHeader", owner: nil, options: nil)?.first as? LeagueDetailsHeader {
            header.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(header)
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                header.heightAnchor.constraint(equalToConstant: 80)
            ])
            globalHeader = header
            globalHeader?.delegate = self
            
            globalHeader?.configure(title: NSLocalizedString("leagues", comment: ""), country: "", showTabs: false, showBackButton: true, showHeader: true, showFavBtn: false)
        }
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = AppColor.bgSurface2
        textField.textColor = AppColor.textPrimary
        
        tableView.isSkeletonable = true
    }
    
    private func setupEmptyStates() {
      
        noResultsLabel.textColor = AppColor.textSecondary
        noResultsLabel.font = AppFont.bodyMedium
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true
        view.addSubview(noResultsLabel)
        noResultsLabel.text = NSLocalizedString("no_leagues_found", comment: "")
    
        noInternetLabel.text = NSLocalizedString("no_internet", comment: "")

        noInternetLabel.numberOfLines = 0
        noInternetLabel.textColor = AppColor.textSecondary
        noInternetLabel.font = AppFont.bodyMedium
        noInternetLabel.textAlignment = .center
        noInternetLabel.isHidden = true
        view.addSubview(noInternetLabel)
        
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        noInternetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noResultsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            noInternetLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            noInternetLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func setupSearchBinding() {
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.presenter.search(query: query)
            })
            .disposed(by: disposeBag)
            
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    func showLoading() {
        showNoResults(isHidden: true)
        
        tableView.isHidden = false
        tableView.showAnimatedGradientSkeleton()
    }
    
    func hideLoading() {
        tableView.hideSkeleton()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
       
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showNoResults(isHidden: Bool) {
        noResultsLabel.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
    

    func showNoInternet() {
        DispatchQueue.main.async {
            
            self.noInternetView.isHidden = false
        }
    }

    func hideNoInternet() {
        DispatchQueue.main.async {
            self.noInternetView.isHidden = true
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLeaguesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as? LeagueTableViewCell else {
            return UITableViewCell()
        }
        let league = presenter.getLeague(at: indexPath.row)
        cell.configure(with: league)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    func navigateToLeagueDetails(with league: League) {
        guard let leagueDetailsVC = storyboard?.instantiateViewController(withIdentifier: "leagueDetailsScreen") as? LeagueDetailsViewController else {
            return
        }
        leagueDetailsVC.leagueIdPassed = league.id
        self.navigationController?.pushViewController(leagueDetailsVC, animated: true)
    }
    
    func setGameHeader(sportName: String) {
     

        globalHeader?.configure(title: NSLocalizedString("leagues", comment: ""), country: sportName, showTabs: false, showBackButton: true, showHeader: true, showFavBtn: false)
    }
}

extension LeaguesViewController: LeagueDetailsHeaderDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    func didSelectTab(index: Int) {}
    func didTapFavourite() {}
    func didTapThemeButton() {}
    func didSelectLanguage(_ code: String) {}
}
