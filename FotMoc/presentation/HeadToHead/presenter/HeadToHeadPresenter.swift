//
//  HeadToHeadPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation



protocol HeadToHeadPresenter: AnyObject {
    func attachView(_ view: HeadToHeadView)
    func detachView()
    func loadData(teamId1: String, teamId2: String, leagueId: String)
    func didTapBack()
    func retryLoading()
}
