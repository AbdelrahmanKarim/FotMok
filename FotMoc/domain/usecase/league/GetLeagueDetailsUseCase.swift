//
//  getLeagueDetailsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeagueDetailsUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws -> League {
        return try await repository.getLeagueDetails(leagueId: leagueId)
    }
}
