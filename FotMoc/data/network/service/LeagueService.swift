//
//  LeagueService.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class LeagueService {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchLeagues(sport: String) async throws -> ResultDTO<[LeagueDTO]> {
        fatalError()
    }
    
    func fetchLeagueDetails(sport: String, leagueId: String) async throws -> ResultDTO<[LeagueDTO]> {
        fatalError()
    }
    
    func fetchStandings(sport: String, leagueId: String) async throws -> ResultDTO<[StandingDTO]> {
        fatalError()
    }
}
