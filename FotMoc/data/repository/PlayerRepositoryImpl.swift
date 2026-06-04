//
//  PlayerRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class PlayerRepositoryImpl: PlayerRepository {
    private let remoteDataSource: PlayerRemoteDataSource
    private let sportProvider: CurrentSportProvider
        
    init(remoteDataSource: PlayerRemoteDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.sportProvider = sportProvider
    }
    
    func getLeaguePlayers(leagueId: String) async throws -> [Player] { fatalError() }
    func getPlayerDetails(playerId: String) async throws -> Player { fatalError() }
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats { fatalError() }
    func getTeamPlayers(teamId: String) async throws -> [Player] { fatalError() }
    
    func getLeagueTopScorers(leagueId: String) async throws -> [TopScorer] {
        let sport = sportProvider.selectedSport
        let dtos = try await remoteDataSource.getTopScorers(sport: sport.rawValue, leagueId: leagueId)
        return dtos.map { $0.toEntity() } 
    }
}
