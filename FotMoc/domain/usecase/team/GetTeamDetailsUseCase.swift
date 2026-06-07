//
//  getTeamDetailsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetTeamDetailsUseCase {
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func execute(teamId: String) async throws -> Team {
        return try await repository.getTeamDetails(teamId: teamId)
    }
}
