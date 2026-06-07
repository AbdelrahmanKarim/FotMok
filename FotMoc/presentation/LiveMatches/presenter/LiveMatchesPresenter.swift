//
//  LiveMatchesPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol LiveMatchesPresenter : AnyObject {
    func attachView(_ view: LiveMatchesView)
     func detachView()
     func loadLiveMatches()
    func retryLoading()
    func didTapBack()
}
