//
//  PlayerRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class PlayerRepositoryImpl: PlayerRepository {
    
    private let remoteDataSource: PlayerRemoteDataSource
        
    init(remoteDataSource: PlayerRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    func getLeaguePlayers(leagueId: String) async throws -> [Player] {
        fatalError()
    }
    
    func getLeagueTopScorers(leagueId: String) async throws -> [TopScorer] {
        fatalError()
    }
    
    func getPlayerDetails(playerId: String) async throws -> Player {
        fatalError()
    }
    
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats {
        fatalError()
    }
    
    func getTeamPlayers(teamId: String) async throws -> [Player] {
        fatalError()
    }
}
