//
//  LeagueRepositoryImpl.swift
//  FotMoc
//

import RxSwift
import Factory

class LeagueRepositoryImpl: LeagueRepository {
    private let remoteDataSource: LeagueRemoteDataSource
    private let localDataSource: LeagueLocalDataSource
    private let sportProvider: CurrentSportProvider
        
   init(remoteDataSource: LeagueRemoteDataSource, localDataSource: LeagueLocalDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.sportProvider = sportProvider
    }
    
    func getFavouriteLeagues() async throws -> [League] {
        return try localDataSource.getFavouriteLeagues()
    }
    
    func getLeagueDetails(leagueId: String) async throws -> League {
        throw AppException.custom(message: "Not implemented")
    }
    
    func getLeagues(sport: SportType) async throws -> [League] {
        let leagueDTO = try await remoteDataSource.getLeagues(sport: sport)
        return leagueDTO.map { dto in
            dto.toEntity(sport: sport)
        }
    }
        
    func getLeagueTableStandings(leagueId: String) async throws -> [StandingRow] {
        let sport = sportProvider.selectedSport
        let dtos = try await remoteDataSource.getLeagueTableStandings(sport: sport.rawValue, leagueId: leagueId)
        return dtos.map { $0.toEntity(sport: sport) }
    }
    
    func saveFavouriteLeague(league: League) async throws {
        try localDataSource.saveFavouriteLeague(league: league)
    }

    func removeFavouriteLeague(id: String) async throws {
        try localDataSource.removeFavouriteLeague(id: id)
    }
    
    func searchLeagues(query: String) -> Observable<[League]> {
        let currentSport = sportProvider.selectedSport
        return remoteDataSource.searchLeagues(sport: currentSport, query: query)
            .map { filteredDTOs in
                filteredDTOs.map { dto in
                    dto.toEntity(sport: currentSport)
                }
            }
    }
}
