//
//  LeaguesView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//



import Foundation

protocol LeaguesView: AnyObject {
    func showLoading()
    func hideLoading()
    func reloadData()
    func showError(_ message: String)
    func showNoResults(isHidden: Bool)
  
    func navigateToLeagueDetails(with league: League)
    func setGameHeader(sportName: String)
    func showNoInternet()
     func hideNoInternet()
}
