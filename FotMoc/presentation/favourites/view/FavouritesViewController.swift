//
//  FavouritesViewController.swift
//  FotMoc
//
//  Created by abdelrahman karim on 21/05/2026.
//


import UIKit
import Factory
class FavouritesViewController: UIViewController , FavouritesView{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var browseMorePlusIcon: UIImageView!
    @IBOutlet weak var browseMoreLabel: UILabel!
    @IBOutlet weak var browseMoreView: DashedBorderView!
    private let emptyLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    @Injected(\.favouritesPresenter) private var presenter: FavouritesPresenter
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(UINib(nibName: "LeagueTableViewCell", bundle: nil), forCellReuseIdentifier: "leagueCell")
        tableView.dataSource = self
        tableView.delegate = self
        presenter.attachView(self)
        browseMoreView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBrowseMore))
        browseMoreView.addGestureRecognizer(tapGesture)
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.viewWillAppear()
        }
        
        func showFavourites(_ leagues: [League]) {
            tableView.reloadData()
        }
    @objc private func didTapBrowseMore() {
        guard let leaguesVC = storyboard?.instantiateViewController(withIdentifier: "leagueScreen") else { return }
        self.navigationController?.pushViewController(leaguesVC, animated: true)
    }
    func showLoading() {
            activityIndicator.startAnimating()
            activityIndicator.center = view.center
            view.addSubview(activityIndicator)
        }

        func hideLoading() {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
        func showEmptyState(isHidden: Bool) {
            if !isHidden {
                emptyLabel.text = "No favourites added yet."
                emptyLabel.textColor = .lightGray
                emptyLabel.textAlignment = .center
                emptyLabel.frame = tableView.bounds
                tableView.backgroundView = emptyLabel
            } else {
                tableView.backgroundView = nil
            }
        }
    private func setupUI() {
        view.backgroundColor = AppColor.bgPrimary
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "LeagueTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "leagueCell")
        titleLabel.textColor = AppColor.textPrimary
        titleLabel.font = AppFont.h1
        browseMoreView.backgroundColor = AppColor.bgSurface
        browseMoreLabel.textColor = AppColor.textSecondary
        browseMorePlusIcon.tintColor = AppColor.textSecondary
        browseMoreLabel.font = AppFont.bodyMedium
    }
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getLeaguesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as! LeagueTableViewCell
        cell.configure(with: presenter.getLeague(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeFavourite(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 97
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedLeague = presenter.getLeague(at: indexPath.row)
            guard let leagueDetailsVC = storyboard?.instantiateViewController(withIdentifier: "leagueDetailsScreen") as? LeagueDetailsViewController else {
                print("Error: Could not find leagueDetailsScreen in Storyboard")
                return
            }
            leagueDetailsVC.leagueIdPassed = selectedLeague.id
            self.navigationController?.pushViewController(leagueDetailsVC, animated: true)
        }
}
