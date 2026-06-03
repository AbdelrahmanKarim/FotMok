//
//  getLeagueUpcomingMatchesUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeagueUpcomingMatchesUseCase {
    private let repository: MatchRepository
    
    init(repository: MatchRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws -> [Match] {
        return try await repository.getLeagueUpcomingMatches(leagueId: leagueId)
    }
}
