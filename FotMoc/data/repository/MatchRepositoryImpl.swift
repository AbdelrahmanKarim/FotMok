//
//  MatchRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class MatchRepositoryImpl: MatchRepository {
    private let remoteDataSource: MatchRemoteDataSource
        
    init(remoteDataSource: MatchRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    func getHeadToHeadPreviousMatches(teamId1: String, teamId2: String) async throws -> [Match] {
        fatalError()
    }
    
    func getHeadToHeadUpcomingMatch(teamId1: String, teamId2: String) async throws -> Match {
        fatalError()
    }
    
    func getLeagueLatestMatches(leagueId: String) async throws -> [Match] {
        fatalError()
    }
    
    func getLeagueUpcomingMatches(leagueId: String) async throws -> [Match] {
        fatalError()
    }
    
    func getLiveMatches(sport: SportType) async throws -> [Match] {
        fatalError()
    }
    
    func getMatchDetails(matchId: String) async throws -> Match {
        fatalError()
    }
}
