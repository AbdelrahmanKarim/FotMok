//
//  getTeamPlayersUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetTeamPlayersUseCase {
    private let repository: PlayerRepository
    
    init(repository: PlayerRepository) {
        self.repository = repository
    }
    
    func execute(teamId: String) async throws -> [Player] {
        return try await repository.getTeamPlayers(teamId: teamId)
    }
}
