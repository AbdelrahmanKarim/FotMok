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
import Foundation
class TeamRepositoryImpl: TeamRepository {
    private let remoteDataSource: TeamRemoteDataSource
    private let sportProvider: CurrentSportProvider
        
    init(remoteDataSource: TeamRemoteDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.sportProvider = sportProvider
    }
    
    func getLeagueTeams(leagueId: String) async throws -> [Team] { fatalError() }
    func getTeamDetails(teamId: String) async throws -> Team { fatalError() }
    func getTeamSeasonStats(teamId: String) async throws -> TeamSeasonStats { fatalError() }
    
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
    func getOverallHeadToHeadRecord(teamId1: String, teamId2: String) async throws -> HeadToHeadRecord {
        let sport = sportProvider.selectedSport
        let dto = try await remoteDataSource.getH2H(sport: sport.rawValue, firstTeamId: teamId1, secondTeamId: teamId2)
        return dto.toEntity(targetTeamId: teamId1, opponentTeamId: teamId2)
    }
        
    func getTeamSeasonStats(teamId: String, leagueId: String) async throws -> TeamSeasonStats {
            let sport = sportProvider.selectedSport
            let standings = try await remoteDataSource.getLeagueTableStandings(sport: sport.rawValue, leagueId: leagueId)
            guard let teamRow = standings.first(where: { String($0.teamKey) == teamId }) else {
                throw AppException.notFound
            }
            
            return TeamSeasonStats(
                points: teamRow.standingPTS,
                matchesPlayed: teamRow.standingP,
                goalDifference: teamRow.standingGD,
                wins: teamRow.standingW
            )
        }

        func getTeamRecentForm(teamId: String, leagueId: String) async throws -> TeamRecentForm {
            let sport = sportProvider.selectedSport
            let teamDetails = try await remoteDataSource.getTeamDetails(sport: sport.rawValue, teamId: teamId)
            guard let team = teamDetails.first else { throw AppException.notFound }
            
            let matches = try await remoteDataSource.getTeamRecentFixtures(sport: sport.rawValue, leagueId: leagueId, teamId: teamId)
            
            let sortedMatches = matches.sorted { ($0.eventDate ?? "") > ($1.eventDate ?? "") }
            let last5Matches = Array(sortedMatches.prefix(5))
            
            var formOutcomes: [MatchOutcome] = []
            
            for match in last5Matches {
                let isHome = String(match.homeTeamKey ?? 0) == teamId
                let scoreParts = match.eventFinalResult?.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
                
                if scoreParts.count == 2, let homeScore = Int(scoreParts[0]), let awayScore = Int(scoreParts[1]) {
                    if homeScore == awayScore {
                        formOutcomes.append(.draw)
                    } else if (isHome && homeScore > awayScore) || (!isHome && awayScore > homeScore) {
                        formOutcomes.append(.win)
                    } else {
                        formOutcomes.append(.loss)
                    }
                }
            }
            
            return TeamRecentForm(
                teamId: teamId,
                teamName: team.teamName,
                logoUrl: URL(string: team.teamLogo),
                form: formOutcomes
            )
        }
}
