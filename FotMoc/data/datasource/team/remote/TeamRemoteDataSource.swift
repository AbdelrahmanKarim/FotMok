//
//  TeamRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol TeamRemoteDataSource {
    func getTeamsInLeague(sport: SportType, leagueId: String) async throws -> [TeamDTO]
    func getTeamDetails(sport: SportType, teamId: String) async throws -> TeamDTO
    func getTeamSeasonStats(sport: SportType, leagueId: String) async throws -> StandingDTO
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO
    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total]
    func getTeamRecentFixtures(sport: String, leagueId: String, teamId: String) async throws -> [MatchDTO]
    func getTeamDetails(sport: String, teamId: String) async throws -> [TeamDTO] 

}
