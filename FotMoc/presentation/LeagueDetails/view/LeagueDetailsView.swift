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
    func updateFavouriteIcon(isFavourite: Bool)
    func navigateToH2H(teamId1: String, teamId2: String, leagueId: String, title: String)
    func navigateToTeamDetails(teamId: String, leagueId: String)
    func navigateToPlayerProfile(playerId: String)
}

