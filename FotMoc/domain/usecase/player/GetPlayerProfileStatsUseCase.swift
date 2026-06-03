//
//  getPlayerProfileStatsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetPlayerProfileStatsUseCase {
    private let repository: PlayerRepository
    
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    func execute(playerId: String) async throws -> PlayerProfileStats {
        return try await repository.getPlayerProfileStats(playerId: playerId)
    }
}
