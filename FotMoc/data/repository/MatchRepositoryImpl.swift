//
//  MatchRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import Foundation
import Factory
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
        let currentSport = Container.shared.activeSport()
                
        guard let matchDTO = try await remoteDataSource.getMatchDetails(sport: currentSport, matchId: matchId) else {
                    throw NSError(
                        domain: "MatchRepositoryError",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Match details could not be found or processed."]
                    )
                }
                
                
                return matchDTO.toEntity(sport: currentSport)
    }
}
