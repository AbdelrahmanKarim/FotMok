//
//  LeagueDetailsView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol LeagueDetailsView: AnyObject {
    func showLoading()
    func hideLoading()
    func displayOverviewData(upcoming: [Match], latest: [Match] , teamsOrPlayers : [Any])
    func displayError(message: String)
    func navigateBack()
    func navigateToLatestMatches()
    func displayTableData(standings: [StandingRow])
    func displayLeagueInfo(name: String, country: String)
    func displayTopScorers(scorers: [TopScorer])
}

