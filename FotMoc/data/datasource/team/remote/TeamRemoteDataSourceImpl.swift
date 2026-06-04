//
//  TeamRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

class TeamRemoteDataSourceImpl: TeamRemoteDataSource {
    private let matchService: MatchService
    private let leagueService: LeagueService
    private let teamService: TeamService
    
    init(matchService: MatchService, leagueService: LeagueService,teamService: TeamService) {
        self.matchService = matchService
        self.leagueService = leagueService
        self.teamService = teamService
    }
    
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO {
        do {
            let res = try await matchService.fetchH2H(sport: sport, firstTeamId: firstTeamId, secondTeamId: secondTeamId)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch { throw AppException.map(error) }
    }
    
    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total] {
        do {
            let res = try await leagueService.fetchStandings(sport: sport, leagueId: leagueId)
            guard res.success == 1, let result = res.result?.total else { throw AppException.noData }
            return result
        } catch { throw AppException.map(error) }
    }
    func getTeamRecentFixtures(sport: String, leagueId: String, teamId: String) async throws -> [MatchDTO] {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let today = formatter.string(from: Date())
            let pastDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: -60, to: Date())!)
            
            do {
                let res = try await matchService.fetchFixtures(sport: sport, from: pastDate, to: today, leagueId: leagueId)
                guard res.success == 1, let result = res.result else { throw AppException.noData }
                return result.filter {
                    (String($0.homeTeamKey ?? 0) == teamId || String($0.awayTeamKey ?? 0) == teamId) &&
                    $0.eventStatus == "Finished"
                }
            } catch { throw AppException.map(error) }
        }
    
    func getTeamDetails(sport: String, teamId: String) async throws -> [TeamDTO] {
            do {
                let res = try await teamService.fetchTeamDetails(sport: sport, teamId: teamId)
                guard res.success == 1, let result = res.result else { throw AppException.noData }
                return result
            } catch { throw AppException.map(error) }
        }
}
