//
//  LiveMatchesView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol LiveMatchesView: AnyObject {
    func showLoading()
    func hideLoading(then completion: (() -> Void)?)
    func displayMatches(_ matches: [Match])
    func displayEmptyState()
    func displayError(message: String)
    func showNoInternet()
     func hideNoInternet()
}
