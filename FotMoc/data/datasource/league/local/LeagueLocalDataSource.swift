//
//  LeagueLocalDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol LeagueLocalDataSource {
    func getFavouriteLeagues() throws -> [League]
    func saveFavouriteLeague(league: League) throws
    func removeFavouriteLeague(id: String) throws
}
