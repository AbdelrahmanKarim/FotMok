//
//  TeamRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol TeamRemoteDataSource {
    func getTeamsInLeague(sport: SportType, leagueId: String) async throws -> [TeamDTO]
    func getTeamDetails(sport: SportType, teamId: String) async throws -> TeamDTO?
    func getTeamSeasonStats(sport: SportType, leagueId: String) async throws -> StandingDTO?
}
