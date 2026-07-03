//
//  LatestPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol LatestPresenter  {
    func attachView(_ view: LatestView)
    func detachView()
    func loadLatestMatches(leagueId : String)
    func didTapBack()
    func retryLoading()
}

