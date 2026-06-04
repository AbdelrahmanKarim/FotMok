//
//  RemoveFavouriteLeagueUseCase.swift
//  FotMoc
//
//  Created by Alaa Ayman on 03/06/2026.
//

class RemoveFavouriteLeagueUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(leagueId: String) async throws {
        try await repository.removeFavouriteLeague(id: leagueId)
    }
}
