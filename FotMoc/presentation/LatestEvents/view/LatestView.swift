//
//  LatestView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol LatestView: AnyObject {
    func showLoading()
    func hideLoading(then completion: (() -> Void)?)
    func displayMatches(_ matches: [Match])

    func displayEmptyState()
    func displayError(message: String)
    func navigateBack()
    func showNoInternet()
     func hideNoInternet()
}


