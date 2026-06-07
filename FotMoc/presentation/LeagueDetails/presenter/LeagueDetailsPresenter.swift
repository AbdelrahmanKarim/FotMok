//
//  LeagueDetailsPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol LeagueDetailsPresenter: AnyObject {
    func attachView(_ view: LeagueDetailsView)
    func detachView()
    func loadLeagueContent(leagueId: String)
    func loadTableContent(leagueId: String)
    func didTapBack()
    func didTapShowMoreLatest()
    func loadLeagueDetails(leagueId: String)
    func loadTopScorers(leagueId: String)
    func toggleFavourite()
    func didSelectMatch(_ match: Match, leagueId: String)
    func didSelectTeam(teamId: String)
    func didSelectPlayer(playerId: String)
    func retryLoading()
}


