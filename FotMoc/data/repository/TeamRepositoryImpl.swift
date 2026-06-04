//
//  TeamRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import Factory
import Foundation
class TeamRepositoryImpl: TeamRepository {
    private let remoteDataSource: TeamRemoteDataSource
    
    init(remoteDataSource: TeamRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getLeagueTeams(leagueId: String) async throws -> [Team] {
        let currentSport = Container.shared.activeSport()
        let teamDTOs = try await remoteDataSource.getTeamsInLeague(sport: currentSport, leagueId: leagueId)
        
        let leagueTeams = teamDTOs.map { dto in
            dto.toEntity(sport: currentSport)
        }
        
        return leagueTeams
    }
    
    func getOverallHeadToHeadRecord(teamId1: String, teamId2: String) async throws -> HeadToHeadRecord {
        fatalError()
    }
    
    func getTeamDetails(teamId: String) async throws -> Team {
        let currentSport = Container.shared.activeSport()
        
        guard let dto = try await remoteDataSource.getTeamDetails(sport: currentSport, teamId: teamId) else {
            throw NSError(
                domain: "TeamRepositoryError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Team with ID \(teamId) could not be found."]
            )
        }
        
        let team = dto.toEntity(sport: currentSport)
        
        
        return team
    }
    
    func getTeamRecentForm(teamId: String) async throws -> TeamRecentForm {
        fatalError()
    }
    
    func getTeamSeasonStats(teamId: String) async throws -> TeamSeasonStats {
        let currentSport = Container.shared.activeSport()
        let activeLeagueId = Container.shared.activeLeagueId()
        
        guard let standings = try await remoteDataSource.getTeamSeasonStats(sport: currentSport, leagueId: activeLeagueId) else {
            throw NSError(
                domain: "TeamRepositoryError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Standings dataset unavailable."]
            )
        }
        
        guard let targetIntId = Int(teamId),
              let matchedRow = standings.total.first(where: { $0.teamKey == targetIntId }) else {
            throw NSError(
                domain: "TeamRepositoryError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Stats missing for Team ID \(teamId)."]
            )
        }
        
        return matchedRow.toSeasonStats()
    }
}
