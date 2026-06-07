//
//  getLiveMatchesUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLiveMatchesUseCase {
    private let repository: MatchRepository
    
    init(repository: MatchRepository) {
        self.repository = repository
    }
    
    func execute(sport: SportType) async throws -> [Match] {
        return try await repository.getLiveMatches(sport: sport)
    }
}
