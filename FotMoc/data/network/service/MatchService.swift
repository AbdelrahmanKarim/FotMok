//
//  MatchService.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class MatchService {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
    
    func fetchFixtures(sport: String, from: String, to: String, leagueId: String?) async throws -> ResultDTO<[MatchDTO]> {
        fatalError()
    }
    
    func fetchMatchDetails(sport: String, matchId: String) async throws -> ResultDTO<[MatchDTO]> {
        let parameters: [String: Any] = [
                    "met": "Fixtures",
                    "matchId": matchId
                ]
                return try await network.fetch(sport: sport, parameters: parameters)
    }
    
    func fetchLiveScores(sport: String) async throws -> ResultDTO<[MatchDTO]> {
        fatalError()
    }
    
    func fetchH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> ResultDTO<H2HResponseDTO> {
        fatalError()
    }
}
