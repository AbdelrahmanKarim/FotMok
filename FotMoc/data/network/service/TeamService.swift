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
        fatalError()
    }
    
    func fetchTeamDetails(sport: String, teamId: String) async throws -> ResultDTO<[TeamDTO]> {
        fatalError()
    }
}
