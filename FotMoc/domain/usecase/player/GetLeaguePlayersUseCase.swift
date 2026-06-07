//
//  getLeaguePlayersUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeaguePlayersUseCase {
    private let repository: PlayerRepository
    
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws -> [Player] {
        return try await repository.getLeaguePlayers(leagueId: leagueId)
    }
}
