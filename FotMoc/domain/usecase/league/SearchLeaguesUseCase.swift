//
//  searchLeaguesUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class SearchLeaguesUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [League] {
        return try await repository.searchLeagues(query: query)
    }
}
