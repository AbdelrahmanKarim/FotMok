//
//  saveFavouriteLeagueUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class SaveFavouriteLeagueUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(league: League) async throws {
        try await repository.saveFavouriteLeague(league: league)
    }
}
