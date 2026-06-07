//
//  PlayerDetailsView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol PlayerProfileView: AnyObject {
    func showLoading()
    func hideLoading()
    func displayPlayerProfile(player: Player, stats: PlayerProfileStats?)
    func displayError(message: String)
    func navigateBack()
    func showNoInternet()
    func hideNoInternet()
        
  
}
