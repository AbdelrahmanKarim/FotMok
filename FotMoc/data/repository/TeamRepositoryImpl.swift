//
//  TeamRepositoryImpl.swift
//  FotMoc
//

import Factory
import Foundation

class TeamRepositoryImpl: TeamRepository {
    private let sportProvider: CurrentSportProvider
    private let remoteDataSource: TeamRemoteDataSource

    init(remoteDataSource: TeamRemoteDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.sportProvider = sportProvider
    }
    
    func getLeagueTeams(leagueId: String) async throws -> [Team] {
        let currentSport = sportProvider.selectedSport
        let teamDTOs = try await remoteDataSource.getTeamsInLeague(sport: currentSport, leagueId: leagueId)
        return teamDTOs.map { dto in
            dto.toEntity(sport: currentSport)
        }
    }
    
    func getTeamDetails(teamId: String) async throws -> Team {
        let currentSport = sportProvider.selectedSport
        let dto = try await remoteDataSource.getTeamDetails(sport: currentSport, teamId: teamId)
        return dto.toEntity(sport: currentSport)
    }

    func getOverallHeadToHeadRecord(teamId1: String, teamId2: String) async throws -> HeadToHeadRecord {
        let sport = sportProvider.selectedSport
        let dto = try await remoteDataSource.getH2H(sport: sport.rawValue, firstTeamId: teamId1, secondTeamId: teamId2)
        return dto.toEntity(targetTeamId: teamId1, opponentTeamId: teamId2)
    }
    
    func getTeamSeasonStats(teamId: String, leagueId: String) async throws -> TeamSeasonStats {
        let sport = sportProvider.selectedSport
        let standings = try await remoteDataSource.getLeagueTableStandings(sport: sport.rawValue, leagueId: leagueId)
        
        guard let teamRow = standings.first(where: { String($0.teamKey ?? 0) == teamId }) else {
            throw AppException.notFound
        }
        
        return TeamSeasonStats(
            points: teamRow.standingPTS ?? 0,
            matchesPlayed: teamRow.standingP ?? 0,
            goalDifference: teamRow.standingGD ?? 0,
            wins: teamRow.standingW ?? 0
        )
    }
    
    func getTeamRecentForm(teamId: String, leagueId: String) async throws -> TeamRecentForm {
        let sport = sportProvider.selectedSport
        
        let team = try await remoteDataSource.getTeamDetails(sport: sport, teamId: teamId)
        
        let matches = try await remoteDataSource.getTeamRecentFixtures(sport: sport.rawValue, leagueId: leagueId, teamId: teamId)
        let sortedMatches = matches.sorted { ($0.eventDate ?? "") > ($1.eventDate ?? "") }
        let last5Matches = Array(sortedMatches.prefix(5))
        
        var formOutcomes: [MatchOutcome] = []
        
        for match in last5Matches {
            let isHome = String(match.homeTeamKey ?? 0) == teamId
            let scoreParts = (match.eventFinalResult ?? "").split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }
            
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
            teamName: team.teamName ?? "Unknown",
            logoUrl: team.teamLogo != nil ? URL(string: team.teamLogo!) : nil,
            form: formOutcomes
        )
    }
}
