//
//  LeaguesViewController.swift
//  FotMoc
//
//  Created by abdelrahman karim on 21/05/2026.
//

//
//  LeaguesViewController.swift
//  FotMoc
//
//  Created by abdelrahman karim on 21/05/2026.
//

import UIKit

class LeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var gameHeader: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        searchBar.layoutMargins = .zero
        searchBar.directionalLayoutMargins = .zero
        searchBar.searchTextField.layoutMargins = .zero
        backButton.backgroundColor = AppColor.bgSurface
        backButton.tintColor = AppColor.textPrimary
        backButton.layer.cornerRadius = 17
        backButton.clipsToBounds = true
        let textField = searchBar.searchTextField
        textField.backgroundColor = AppColor.bgSurface2
        textField.textColor = AppColor.textPrimary
        textField.font = AppFont.body
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.textSecondary,
            .font: AppFont.body
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        textField.leftView?.tintColor = AppColor.textSecondary
        textField.rightView?.tintColor = AppColor.textSecondary
    }
}
