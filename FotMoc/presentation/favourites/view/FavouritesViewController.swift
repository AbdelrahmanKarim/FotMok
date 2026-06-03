//
//  FavouritesViewController.swift
//  FotMoc
//
//  Created by abdelrahman karim on 21/05/2026.
//


import UIKit

class FavouritesViewController: UIViewController , FavouritesView{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var browseMoreLabel: UILabel!
    @IBOutlet weak var browseMoreView: DashedBorderView!
    
    let mockLeagues = [
        ("Egypt Premier League", "EG Egypt"),
        ("English Premier League", "England"),
        ("Champions League", "Europe"),
        ("La Liga", "ES Spain")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
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
        browseMoreLabel.font = AppFont.bodyMedium
    }
}

extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leagueCell", for: indexPath) as? LeagueTableViewCell else {
            return UITableViewCell()
        }
        
        let league = mockLeagues[indexPath.row]
        
        cell.leagueTitle.text = league.0
        cell.leagueCountry.text = league.1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
