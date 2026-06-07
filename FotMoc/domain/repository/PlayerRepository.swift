//
//  PlayerRepository.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

protocol PlayerRepository {
    func getLeaguePlayers(leagueId: String) async throws -> [Player]
    func getLeagueTopScorers(leagueId: String) async throws -> [TopScorer]
    func getPlayerDetails(playerId: String) async throws -> Player
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats
    func getTeamPlayers(teamId: String) async throws -> [Player]
}
