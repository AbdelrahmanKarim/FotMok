//
//  PlayerRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol PlayerRemoteDataSource {
    func getTopScorers(sport: String, leagueId: String) async throws -> [TopScorerDTO]
}
