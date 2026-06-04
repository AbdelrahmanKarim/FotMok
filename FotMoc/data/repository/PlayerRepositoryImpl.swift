//
//  PlayerRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import Factory
import Foundation
class PlayerRepositoryImpl: PlayerRepository {
    private let remoteDataSource: PlayerRemoteDataSource
    private let teamRemoteDataSource: TeamRemoteDataSource
    init(remoteDataSource: PlayerRemoteDataSource, teamRemoteDataSource : TeamRemoteDataSource,sportProvider: CurrentSportProvider) {
            self.remoteDataSource = remoteDataSource
            self.teamRemoteDataSource = teamRemoteDataSource
            self.sportProvider = sportProvider

        }
    
    func getLeaguePlayers(leagueId: String) async throws -> [Player] {
        let currentSport = Container.shared.activeSport()
        let teams = try await teamRemoteDataSource.getTeamsInLeague(sport: currentSport, leagueId: leagueId)
                
               
                let leaguePlayers = teams.flatMap { team -> [Player] in
                    let teamIdString = String(team.teamKey)
                    
                    return team.players.map { playerDTO in
                        playerDTO.toEntity(teamId: teamIdString)
                    }
                }
                
               
                return leaguePlayers
    }
    
    func getLeaguePlayers(leagueId: String) async throws -> [Player] { fatalError() }
    func getPlayerDetails(playerId: String) async throws -> Player { fatalError() }
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats { fatalError() }
    func getTeamPlayers(teamId: String) async throws -> [Player] { fatalError() }
    
    func getPlayerDetails(playerId: String) async throws -> Player {
        let currentSport = Container.shared.activeSport()
            
            guard let dto = try await remoteDataSource.getPlayerDetails(sport: currentSport, playerId: playerId) else {
                throw NSError(
                    domain: "PlayerRepositoryError",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Player profile not found on server."]
                )
            }
            
            return dto.toEntity()
    }
    
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats {
        let currentSport = Container.shared.activeSport()
        guard let dto = try await remoteDataSource.getPlayerDetails(sport: currentSport, playerId: playerId) else {
        throw NSError(
                        domain: "PlayerRepositoryError",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey: "Player statistics not found on server."]
                    )
                }
                
        return dto.toProfileStats()
    }
    
    func getTeamPlayers(teamId: String) async throws -> [Player] {
        let currentSport = Container.shared.activeSport()
            
            guard let teamDTO = try await teamRemoteDataSource.getTeamDetails(sport: currentSport, teamId: teamId) else {
                throw NSError(
                    domain: "PlayerRepositoryError",
                    code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "Team roster could not be found on the server."]
                )
            }
            
            let teamPlayers = teamDTO.players.map { playerDTO in
                playerDTO.toEntity(teamId: teamId)
            }
       
            return teamPlayers
    func getLeagueTopScorers(leagueId: String) async throws -> [TopScorer] {
        let sport = sportProvider.selectedSport
        let dtos = try await remoteDataSource.getTopScorers(sport: sport.rawValue, leagueId: leagueId)
        return dtos.map { $0.toEntity() } 
    }
}
