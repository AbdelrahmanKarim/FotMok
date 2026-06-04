//
//  MatchRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol MatchRemoteDataSource {
    func getFixtures(sport: String, from: String, to: String, leagueId: String?) async throws -> [MatchDTO]
    func getLiveScores(sport: String) async throws -> [MatchDTO]
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO
}
