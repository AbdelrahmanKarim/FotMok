//
//  LeagueRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol LeagueRemoteDataSource {
    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total]
}
