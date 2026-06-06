//
//  TeamDetailsView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol TeamDetailsView: AnyObject {
    func showLoading()
    func hideLoading()
    func displayTeamDetails(team: Team, stats: TeamSeasonStats?, players: [Player])
    func displayError(message: String)
    func navigateBack()
    func navigateToPlayerProfile(playerId: String)
}
