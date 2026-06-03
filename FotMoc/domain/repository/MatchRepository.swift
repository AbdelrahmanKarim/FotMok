//
//  MatchRepository.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

protocol MatchRepository {
    func getHeadToHeadPreviousMatches(teamId1: String, teamId2: String) async throws -> [Match]
    func getHeadToHeadUpcomingMatch(teamId1: String, teamId2: String) async throws -> Match
    func getLeagueLatestMatches(leagueId: String) async throws -> [Match]
    func getLeagueUpcomingMatches(leagueId: String) async throws -> [Match]
    func getLiveMatches(sport: SportType) async throws -> [Match]
    func getMatchDetails(matchId: String) async throws -> Match
}
