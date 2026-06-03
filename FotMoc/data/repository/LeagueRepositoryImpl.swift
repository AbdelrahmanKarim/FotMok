//
//  LeagueRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import RxSwift
import Factory
class LeagueRepositoryImpl: LeagueRepository {
    
    private let remoteDataSource: LeagueRemoteDataSource
    private let localDataSource: LeagueLocalDataSource
        
    init(remoteDataSource: LeagueRemoteDataSource, localDataSource: LeagueLocalDataSource) {
            self.remoteDataSource = remoteDataSource
            self.localDataSource = localDataSource
    }
    
    func getFavouriteLeagues() async throws -> [League] {
        return try localDataSource.getFavouriteLeagues()
      
    }
    
    func getLeagueDetails(leagueId: String) async throws -> League {
        fatalError()
    }
    
    func getLeagues(sport: SportType) async throws -> [League] {
        let leagueDTO = try await remoteDataSource.getLeagues(sport: sport)

            let leagues = leagueDTO.map { dto in
                dto.toEntity(sport: sport)
            }
      
            return leagues
    }
    
    func getLeagueTableStandings(leagueId: String) async throws -> [StandingRow] {
        fatalError()
    }
    
    func saveFavouriteLeague(league: League) async throws {
        return try localDataSource.saveFavouriteLeague(league: league)
    }
    func removeFavouriteLeague(id: String) async throws {
            try localDataSource.removeFavouriteLeague(id: id)
    }
    func searchLeagues(query: String) -> Observable<[League]> {
            let currentSport = Container.shared.activeSport()

            return remoteDataSource.searchLeagues(sport: currentSport, query: query)
                .map { filteredDTOs in
                    filteredDTOs.map { dto in
                        dto.toEntity(sport: currentSport)
                    }
                }
        }
}
