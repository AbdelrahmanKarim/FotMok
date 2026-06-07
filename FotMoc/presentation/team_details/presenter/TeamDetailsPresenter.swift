//
//  TeamDetailsPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol TeamDetailsPresenter: AnyObject {
    func attachView(_ view: TeamDetailsView)
    func detachView()
    func loadTeamData(teamId: String, leagueId: String)
    func didSelectPlayer(at index: Int)
    func didTapBack()
    func retryLoading()
}
