//
//  getTeamRecentFormUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetTeamRecentFormUseCase {
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func execute(teamId: String,leagueId:String) async throws -> TeamRecentForm {
        return try await repository.getTeamRecentForm(teamId: teamId,leagueId: leagueId)
    }
}
