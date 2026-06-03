//
//  getLeagueTableStandingsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeagueTableStandingsUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws -> [StandingRow] {
        return try await repository.getLeagueTableStandings(leagueId: leagueId)
    }
}
