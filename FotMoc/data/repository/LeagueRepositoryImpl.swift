//
//  LeagueRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
class LeagueRepositoryImpl: LeagueRepository {
    
    private let remoteDataSource: LeagueRemoteDataSource
    private let localDataSource: LeagueLocalDataSource
        
    init(remoteDataSource: LeagueRemoteDataSource, localDataSource: LeagueLocalDataSource) {
            self.remoteDataSource = remoteDataSource
            self.localDataSource = localDataSource
    }
    
    func getFavouriteLeagues() async throws -> [League] {
        fatalError()
    }
    
    func getLeagueDetails(leagueId: String) async throws -> League {
        fatalError()
    }
    
    func getLeagues(sport: SportType) async throws -> [League] {
        fatalError()
    }
    
    func getLeagueTableStandings(leagueId: String) async throws -> [StandingRow] {
        fatalError()
    }
    
    func saveFavouriteLeague(league: League) async throws {
        fatalError()
    }
    
    func searchLeagues(query: String) async throws -> [League] {
        fatalError()
    }
}
