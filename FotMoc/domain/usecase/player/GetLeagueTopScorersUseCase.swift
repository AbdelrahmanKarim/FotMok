//
//  getLeagueTopScorersUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeagueTopScorersUseCase {
    private let repository: PlayerRepository
    
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws -> [TopScorer] {
        return try await repository.getLeagueTopScorers(leagueId: leagueId)
    }
}
