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
        let parameters: [String: Any] = ["met": "Leagues"]
        return try await network.fetch(sport: sport, parameters: parameters)
    }
    
        
        func fetchStandings(sport: String, leagueId: String) async throws -> ResultDTO<StandingDTO> {
            return try await network.fetch(sport: sport, parameters: ["met": "Standings", "leagueId": leagueId])
        }
    
    func fetchTennisStandings( leagueId: String) async throws -> ResultDTO<StandingDTO> {
        return try await network.fetch(sport: "tennis", parameters: ["met": "Standings", "league": leagueId])
    }
    
}
