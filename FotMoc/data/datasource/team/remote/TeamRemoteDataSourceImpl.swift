//
//  TeamRemoteDataSourceImpl.swift
//  FotMoc
//

import Foundation

class TeamRemoteDataSourceImpl: TeamRemoteDataSource {
    private let matchService: MatchService
    private let leagueService: LeagueService
    private let teamService: TeamService
    
    init(matchService: MatchService, leagueService: LeagueService, teamService: TeamService) {
        self.matchService = matchService
        self.leagueService = leagueService
        self.teamService = teamService
    }

    func getTeamsInLeague(sport: SportType, leagueId: String) async throws -> [TeamDTO] {
        do {
            let response = try await teamService.fetchTeamsInLeague(sport: sport.rawValue, leagueId: leagueId)
            guard let teamDTOs = response.result else { throw AppException.noData }
            return teamDTOs
        } catch {
            throw AppException.map(error)
        }
    }
    
    func getTeamDetails(sport: SportType, teamId: String) async throws -> TeamDTO {
        do {
            let response = try await teamService.fetchTeamDetails(sport: sport.rawValue, teamId: teamId)
            guard let detailedTeam = response.result?.first else { throw AppException.notFound }
            return detailedTeam
        } catch {
            throw AppException.map(error)
        }
    }

    func getTeamSeasonStats(sport: SportType, leagueId: String) async throws -> StandingDTO {
        do {
            let response = try await leagueService.fetchStandings(sport: sport.rawValue, leagueId: leagueId)
            guard let teamSeasonStats = response.result else { throw AppException.noData }
            return teamSeasonStats
        } catch {
            throw AppException.map(error)
        }
    }
    
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO {
        do {
            let res = try await matchService.fetchH2H(sport: sport, firstTeamId: firstTeamId, secondTeamId: secondTeamId)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }
    
    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total] {
        do {
            let res = try await leagueService.fetchStandings(sport: sport, leagueId: leagueId)
            guard res.success == 1, let result = res.result?.total else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }

    func getTeamRecentFixtures(sport: String, leagueId: String, teamId: String) async throws -> [MatchDTO] {
       
        let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.calendar = Calendar(identifier: .gregorian)
           let today = formatter.string(from: Date())
           let pastDate = formatter.string(from: Calendar.current.date(byAdding: .day, value: -60, to: Date())!)
        do {
            let res = try await matchService.fetchFixtures(sport: sport, leagueId: leagueId, from: pastDate, to: today)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result.filter {
                (String($0.homeTeamKey ?? 0) == teamId || String($0.awayTeamKey ?? 0) == teamId) &&
                $0.eventStatus == "Finished"
            }
        } catch {
            throw AppException.map(error)
        }
    }
    
    func getTeamDetails(sport: String, teamId: String) async throws -> [TeamDTO] {
        do {
            let res = try await teamService.fetchTeamDetails(sport: sport, teamId: teamId)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }
}
