//
//  TeamRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

class TeamRemoteDataSourceImpl: TeamRemoteDataSource {
    private let service: TeamService
    private let leagueService: LeagueService
        init(service: TeamService, leagueService: LeagueService) {
            self.service = service
            self.leagueService = leagueService
        }
    func getTeamsInLeague(sport: SportType, leagueId: String) async throws -> [TeamDTO] {
            let response = try await service.fetchTeamsInLeague(sport: sport.rawValue, leagueId: leagueId)
        
        guard let teamDTOs = response.result else {
            return []
        }
        return teamDTOs
    }
    
    func getTeamDetails(sport: SportType, teamId: String) async throws -> TeamDTO? {
            let response = try await service.fetchTeamDetails(sport: sport.rawValue, teamId: teamId)
           guard let detailedTeam = response.result?.first else {
                    return nil
                }
                return detailedTeam
        
        }
    func getTeamSeasonStats(sport: SportType, leagueId: String) async throws -> StandingDTO? {
        let response = try await leagueService.fetchStandings(sport: sport.rawValue, leagueId: leagueId)
        guard let teamSeasonStats = response.result else {
                 return nil
             }

        return teamSeasonStats
        }
    
}
