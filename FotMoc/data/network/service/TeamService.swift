//
//  TeamService.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class TeamService {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchTeamsInLeague(sport: String, leagueId: String) async throws -> ResultDTO<[TeamDTO]> {
        let parameters: [String: Any] = [
                    "met": "Teams",
                    "leagueId": leagueId
                ]
                return try await network.fetch(sport: sport, parameters: parameters)
    }
    
    func fetchTeamDetails(sport: String, teamId: String) async throws -> ResultDTO<[TeamDTO]> {
        let parameters: [String: Any] = [
                    "met": "Teams",
                    "teamId": teamId
                ]
                return try await network.fetch(sport: sport, parameters: parameters)
        
    }

}
