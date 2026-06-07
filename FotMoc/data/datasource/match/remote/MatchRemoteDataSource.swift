//
//  MatchRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol MatchRemoteDataSource {
    func getMatchDetails(sport: SportType, matchId: String) async throws -> MatchDTO
    func getFixtures(sport: String, leagueId: String?, from: String, to: String) async throws -> [MatchDTO]
    func getLiveScores(sport: String) async throws -> [MatchDTO]
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO
}
