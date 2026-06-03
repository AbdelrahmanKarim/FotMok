//
//  getFavouriteLeaguesUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetFavouriteLeaguesUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [League] {
        return try await repository.getFavouriteLeagues()
    }
}
