import UIKit
import SkeletonView
import RxSwift
import RxCocoa
import Factory

class LeaguesViewController: UIViewController, UITableViewDelegate,SkeletonTableViewDataSource ,UITableViewDataSource,UISearchBarDelegate, LeaguesView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gameHeader: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @Injected(\.leaguesPresenter) private var presenter: LeaguesPresenter
    private let disposeBag = DisposeBag()
    
    private let noResultsLabel = UILabel()
    private let noInternetLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEmptyStates()
        setupSearchBinding()
        
        tableView.dataSource = self
        tableView.delegate = self
        presenter.attachView(self)
        presenter.viewDidLoad()
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
        
        titleLabel.textColor = AppColor.textPrimary
        titleLabel.font = AppFont.h2
        gameHeader.textColor = AppColor.textSecondary
        gameHeader.font = AppFont.small
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = .clear
        
        let textField = searchBar.searchTextField
        textField.backgroundColor = AppColor.bgSurface2
        textField.textColor = AppColor.textPrimary
        
        tableView.isSkeletonable = true
    }
    
    private func setupEmptyStates() {
        noResultsLabel.text = "No leagues found."
        noResultsLabel.textColor = AppColor.textSecondary
        noResultsLabel.font = AppFont.bodyMedium
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true
        view.addSubview(noResultsLabel)
        
        noInternetLabel.text = "No internet connection.\nPlease check your settings."
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
        showNoInternet(isHidden: true)
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
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showNoResults(isHidden: Bool) {
        noResultsLabel.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
    
    func showNoInternet(isHidden: Bool) {
        noInternetLabel.isHidden = isHidden
        tableView.isHidden = !isHidden
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
        gameHeader.text = "\(sportName)"
    }
}
