//
//  getMatchDetailsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetMatchDetailsUseCase {
    private let repository: MatchRepository
    
    init(repository: MatchRepository) {
        self.repository = repository
    }
    
    func execute(matchId: String) async throws -> Match {
        return try await repository.getMatchDetails(matchId: matchId)
    }
}
