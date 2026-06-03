//
//  PlayerService.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class PlayerService {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchTopScorers(sport: String, leagueId: String) async throws -> ResultDTO<[TopScorerDTO]> {
        fatalError()
    }
    
    func fetchPlayerDetails(sport: String, playerId: String) async throws -> ResultDTO<[PlayerDTO]> {
        fatalError()
    }
}
