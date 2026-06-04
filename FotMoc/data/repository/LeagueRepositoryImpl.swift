//
//  LeagueRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
class LeagueRepositoryImpl: LeagueRepository {
    private let remoteDataSource: LeagueRemoteDataSource
    private let localDataSource: LeagueLocalDataSource
    private let sportProvider: CurrentSportProvider
        
    init(remoteDataSource: LeagueRemoteDataSource, localDataSource: LeagueLocalDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.sportProvider = sportProvider
    }
    
    func getFavouriteLeagues() async throws -> [League] { fatalError() }
    func getLeagues(sport: SportType) async throws -> [League] { fatalError() }
    func saveFavouriteLeague(league: League) async throws { fatalError() }
    func searchLeagues(query: String) async throws -> [League] { fatalError() }
    
        
    func getLeagueTableStandings(leagueId: String) async throws -> [StandingRow] {
        let sport = sportProvider.selectedSport
        let dtos = try await remoteDataSource.getLeagueTableStandings(sport: sport.rawValue, leagueId: leagueId)
        return dtos.map { $0.toEntity(sport: sport) }
    }
}
