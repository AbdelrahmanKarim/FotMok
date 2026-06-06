//
//  PlayerDetailsPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//
import Foundation

protocol PlayerProfilePresenter: AnyObject {
    func attachView(_ view: PlayerProfileView)
    func detachView()
    func loadPlayerData(playerId: String)
    func didTapBack()
}
