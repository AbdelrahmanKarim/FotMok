//
//  searchLeaguesUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import RxSwift
class SearchLeaguesUseCase {
    private let repository: LeagueRepository
    
    init(repository: LeagueRepository) {
        self.repository = repository
    }
    
    func execute(query: String) -> Observable<[League]> {
            return repository.searchLeagues(query: query)
        }
}
