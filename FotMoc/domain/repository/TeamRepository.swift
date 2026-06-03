//
//  TeamRepository.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

protocol TeamRepository {
    func getLeagueTeams(leagueId: String) async throws -> [Team]
    func getOverallHeadToHeadRecord(teamId1: String, teamId2: String) async throws -> HeadToHeadRecord
    func getTeamDetails(teamId: String) async throws -> Team
    func getTeamRecentForm(teamId: String) async throws -> TeamRecentForm
    func getTeamSeasonStats(teamId: String) async throws -> TeamSeasonStats}
