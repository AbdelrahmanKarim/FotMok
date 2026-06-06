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

        if currentSport == .tennis {
            
            let dtos = try await remoteDataSource.getLeaguePlayersList(sport: currentSport, leagueId: leagueId)
            return dtos.map { dto in
                Player(
                    id: String(dto.playerKey ?? 0),
                    name: dto.playerName ?? "Unknown",
                    imageUrl: dto.playerImage.flatMap { URL(string: $0) },
                    nationality: dto.playerCountry,
                    age: nil, 
                    sportDetails: .tennis(rank: nil, plays: nil)
                )
            }
        }

        // Football/Cricket/Others: extract from teams as before
        let teams = try await teamRemoteDataSource.getTeamsInLeague(sport: currentSport, leagueId: leagueId)
        return teams.flatMap { team -> [Player] in
            let teamIdString = String(team.teamKey ?? 0)
            return (team.players ?? []).map { $0.toEntity(teamId: teamIdString) }
        }
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

        
        let scorers = await withTaskGroup(of: TopScorer.self, returning: [TopScorer].self) { group in
            for dto in dtos {
                group.addTask {
                    var base = dto.toEntity()

                 
                    if let imageUrl = try? await self.fetchPlayerImage(
                        playerId: String(dto.playerKey ?? 0), sport: sport) {
                        let enrichedPlayer = Player(
                            id: base.player.id,
                            name: base.player.name,
                            imageUrl: imageUrl,
                            nationality: base.player.nationality,
                            age: base.player.age,
                            sportDetails: base.player.sportDetails
                        )
                        base = TopScorer(
                            rank: base.rank,
                            player: enrichedPlayer,
                            goals: base.goals,
                            assists: base.assists,
                            teamName: base.teamName
                        )
                    }
                    return base
                }
            }

            var results: [TopScorer] = []
            for await scorer in group {
                results.append(scorer)
            }
           
            return results.sorted { $0.rank < $1.rank }
        }

        return scorers
    }

    private func fetchPlayerImage(playerId: String, sport: SportType) async throws -> URL? {
        let dto = try await remoteDataSource.getPlayerDetails(sport: sport, playerId: playerId)
        guard let img = dto.playerImage, !img.isEmpty else { return nil }
        return URL(string: img)
    }
}
