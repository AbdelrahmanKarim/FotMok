//
//  getHeadToHeadUpcomingMatchUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetHeadToHeadUpcomingMatchUseCase {
    private let repository: MatchRepository
    
    init(repository: MatchRepository) {
        self.repository = repository
    }
    
    func execute(teamId1: String, teamId2: String) async throws -> Match {
        return try await repository.getHeadToHeadUpcomingMatch(teamId1: teamId1, teamId2: teamId2)
    }
}
