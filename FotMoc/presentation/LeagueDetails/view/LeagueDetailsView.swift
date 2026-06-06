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
  
    func displayLeagueInfo(name: String, country: String)
    func displayOverviewData(upcoming: [Match], latest: [Match], teamsOrPlayers: [Any])
    func displayTableData(standings: [StandingRow])
    func displayTopScorers(scorers: [TopScorer])
    func displayError(message: String)
    func updateFavouriteIcon(isFavourite: Bool)
    func navigateBack()
    func navigateToLatestMatches()
    func navigateToH2H(teamId1: String, teamId2: String, leagueId: String, title: String)
    func showNoInternet()
    func hideNoInternet()
    func navigateToTeamDetails(teamId: String, leagueId: String)
    func navigateToPlayerProfile(playerId: String)
}
