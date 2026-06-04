//
//  getTeamSeasonStatsUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetTeamSeasonStatsUseCase {
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func execute(teamId: String,leagueId:String) async throws -> TeamSeasonStats {
        return try await repository.getTeamSeasonStats(teamId: teamId,leagueId: leagueId)
    }
}
