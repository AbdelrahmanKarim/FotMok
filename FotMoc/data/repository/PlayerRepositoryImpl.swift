//
//  PlayerRepositoryImpl.swift
//  FotMoc
//

import Factory
import Foundation

class PlayerRepositoryImpl: PlayerRepository {
    private let remoteDataSource: PlayerRemoteDataSource
    private let teamRemoteDataSource: TeamRemoteDataSource
    private let sportProvider: CurrentSportProvider

    init(remoteDataSource: PlayerRemoteDataSource, teamRemoteDataSource: TeamRemoteDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.teamRemoteDataSource = teamRemoteDataSource
        self.sportProvider = sportProvider
    }
    
    func getLeaguePlayers(leagueId: String) async throws -> [Player] {
        let currentSport = sportProvider.selectedSport
        let teams = try await teamRemoteDataSource.getTeamsInLeague(sport: currentSport, leagueId: leagueId)
        
        let leaguePlayers = teams.flatMap { team -> [Player] in
            let teamIdString = String(team.teamKey ?? 0)
            let playersList = team.players ?? []
            return playersList.map { playerDTO in
                playerDTO.toEntity(teamId: teamIdString)
            }
        }
        
        return leaguePlayers
    }
    
    func getPlayerDetails(playerId: String) async throws -> Player {
        let currentSport = sportProvider.selectedSport
        let dto = try await remoteDataSource.getPlayerDetails(sport: currentSport, playerId: playerId)
        return dto.toEntity()
    }
    
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats {
        let currentSport = sportProvider.selectedSport
        let dto = try await remoteDataSource.getPlayerDetails(sport: currentSport, playerId: playerId)
        return dto.toProfileStats()
    }
    
    func getTeamPlayers(teamId: String) async throws -> [Player] {
        let currentSport = sportProvider.selectedSport
        let teamDTO = try await teamRemoteDataSource.getTeamDetails(sport: currentSport, teamId: teamId)
        
        let teamPlayers = (teamDTO.players ?? []).map { playerDTO in
            playerDTO.toEntity(teamId: teamId)
        }
        
        return teamPlayers
    }

    func getLeagueTopScorers(leagueId: String) async throws -> [TopScorer] {
        let sport = sportProvider.selectedSport
        let dtos = try await remoteDataSource.getTopScorers(sport: sport.rawValue, leagueId: leagueId)
        return dtos.map { $0.toEntity() }
    }
}
