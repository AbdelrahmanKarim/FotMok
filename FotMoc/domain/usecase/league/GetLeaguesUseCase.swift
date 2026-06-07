//
//  getAllLeaguesUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetLeaguesUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(sport: SportType) async throws -> [League] {
        return try await repository.getLeagues(sport: sport)
    }
}
