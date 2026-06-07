//
//  getLeagueTeamsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeagueTeamsUseCase {
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws -> [Team] {
        return try await repository.getLeagueTeams(leagueId: leagueId)
    }
}
