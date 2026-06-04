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
    
    
    func fetchMatchDetails(sport: String, matchId: String) async throws -> ResultDTO<[MatchDTO]> {
        let parameters: [String: Any] = [
                    "met": "Fixtures",
                    "matchId": matchId
                ]
                return try await network.fetch(sport: sport, parameters: parameters)
    }
    
    func fetchFixtures(sport: String, from: String, to: String, leagueId: String?) async throws -> ResultDTO<[MatchDTO]> {
            var params: [String: Any] = ["met": "Fixtures", "from": from, "to": to]
            if let leagueId = leagueId { params["leagueId"] = leagueId }
            return try await network.fetch(sport: sport, parameters: params)
        }
        
    func fetchLiveScores(sport: String) async throws -> ResultDTO<[MatchDTO]> {
            return try await network.fetch(sport: sport, parameters: ["met": "Livescore"])
        }
        
    func fetchH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> ResultDTO<H2HResponseDTO> {
            return try await network.fetch(sport: sport, parameters: ["met": "H2H", "firstTeamId": firstTeamId, "secondTeamId": secondTeamId])
        }
}
