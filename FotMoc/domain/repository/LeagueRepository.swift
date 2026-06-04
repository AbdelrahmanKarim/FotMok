//
//  LeagueRepository.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

protocol LeagueRepository {
    func getFavouriteLeagues() async throws -> [League]
    func getLeagues(sport: SportType) async throws -> [League]
    func getLeagueTableStandings(leagueId: String) async throws -> [StandingRow]
    func saveFavouriteLeague(league: League) async throws
    func searchLeagues(query: String) async throws -> [League]
}
