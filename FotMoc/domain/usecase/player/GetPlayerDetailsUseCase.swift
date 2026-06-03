//
//  getPlayerDetailsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetPlayerDetailsUseCase {
    private let repository: PlayerRepository
    
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    func execute(playerId: String) async throws -> Player {
        return try await repository.getPlayerDetails(playerId: playerId)
    }
}
