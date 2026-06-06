
//
//  RepositoryMocks.swift
//  FotMocTests
//
//  Created by Alaa Ayman on 06/06/2026.
//

import Foundation
import RxSwift
@testable import FotMoc

// MARK: - CurrentSportProvider Mock
class MockCurrentSportProvider: CurrentSportProvider {
    // 1. Create a separate backing variable to hold the test state
    var mockSelectedSport: SportType = .football
    
    // 2. Override the base class property explicitly
    override var selectedSport: SportType {
        get { return mockSelectedSport }
        set { mockSelectedSport = newValue }
    }
}

// MARK: - League Mocks
class MockLeagueRemoteDataSource: LeagueRemoteDataSource {
    var mockLeagues: [LeagueDTO] = []
    var mockStandings: [Total] = []
    var mockSearchObservable: Observable<[LeagueDTO]> = .empty()
    var errorToThrow: Error?

    func getLeagues(sport: SportType) async throws -> [LeagueDTO] {
        if let error = errorToThrow { throw error }
        return mockLeagues
    }

    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total] {
        if let error = errorToThrow { throw error }
        return mockStandings
    }

    func searchLeagues(sport: SportType, query: String) -> Observable<[LeagueDTO]> {
        return mockSearchObservable
    }
}

class MockLeagueLocalDataSource: LeagueLocalDataSource {
    var mockFavouriteLeagues: [League] = []
    var savedLeagues: [League] = []
    var removedLeagueIds: [String] = []
    var errorToThrow: Error?

    func getFavouriteLeagues() throws -> [League] {
        if let error = errorToThrow { throw error }
        return mockFavouriteLeagues
    }

    func saveFavouriteLeague(league: League) throws {
        if let error = errorToThrow { throw error }
        savedLeagues.append(league)
    }

    func removeFavouriteLeague(id: String) throws {
        if let error = errorToThrow { throw error }
        removedLeagueIds.append(id)
    }
}

// MARK: - Player Mocks
class MockPlayerRemoteDataSource: PlayerRemoteDataSource {
    var mockPlayers: [PlayerDTO] = []
    var mockPlayerDetails: PlayerDTO?
    var mockTopScorers: [TopScorerDTO] = []
    var errorToThrow: Error?

    func getLeaguePlayersList(sport: SportType, leagueId: String) async throws -> [PlayerDTO] {
        if let error = errorToThrow { throw error }
        return mockPlayers
    }

    func getPlayerDetails(sport: SportType, playerId: String) async throws -> PlayerDTO {
        if let error = errorToThrow { throw error }
        guard let details = mockPlayerDetails else { throw AppException.noData }
        return details
    }

    func getTopScorers(sport: String, leagueId: String) async throws -> [TopScorerDTO] {
        if let error = errorToThrow { throw error }
        return mockTopScorers
    }
}

// MARK: - Team Mocks
class MockTeamRemoteDataSource: TeamRemoteDataSource {
    var mockTeams: [TeamDTO] = []
    var mockTeamDetails: TeamDTO?
    var mockH2H: H2HResponseDTO?
    var mockStandings: [Total] = []
    var mockRecentFixtures: [MatchDTO] = []
    var errorToThrow: Error?
    
    // Add a specific mock property to satisfy getTeamSeasonStats
    var mockSingleStanding: StandingDTO?

    // Fixed Placeholder 1: Maps your single standing return requirement
    func getTeamSeasonStats(sport: FotMoc.SportType, leagueId: String) async throws -> FotMoc.StandingDTO {
        if let error = errorToThrow { throw error }
        guard let standing = mockSingleStanding else { throw AppException.notFound }
        return standing
    }
    
    // Fixed Placeholder 2: Fallback signature option if your protocol takes String or returns an array variant
    func getTeamDetails(sport: String, teamId: String) async throws -> [FotMoc.TeamDTO] {
        if let error = errorToThrow { throw error }
        if let singleDetail = mockTeamDetails {
            return [singleDetail]
        }
        return []
    }

    func getTeamsInLeague(sport: SportType, leagueId: String) async throws -> [TeamDTO] {
        if let error = errorToThrow { throw error }
        return mockTeams
    }

    func getTeamDetails(sport: SportType, teamId: String) async throws -> TeamDTO {
        if let error = errorToThrow { throw error }
        guard let details = mockTeamDetails else { throw AppException.notFound }
        return details
    }

    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO {
        if let error = errorToThrow { throw error }
        guard let h2h = mockH2H else { throw AppException.noData }
        return h2h
    }

    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total] {
        if let error = errorToThrow { throw error }
        return mockStandings
    }

    func getTeamRecentFixtures(sport: String, leagueId: String, teamId: String) async throws -> [MatchDTO] {
        if let error = errorToThrow { throw error }
        return mockRecentFixtures
    }
}

// MARK: - Match Mocks
class MockMatchRemoteDataSource: MatchRemoteDataSource {
    var mockH2H: H2HResponseDTO?
    var mockFixtures: [MatchDTO] = []
    var mockLiveScores: [MatchDTO] = []
    var mockMatchDetails: MatchDTO?
    var errorToThrow: Error?

    // Fixed Placeholder 3: Standardizes the optional leagueId parameter variant method
    func getFixtures(sport: String, leagueId: String?, from: String, to: String) async throws -> [FotMoc.MatchDTO] {
        if let error = errorToThrow { throw error }
        return mockFixtures
    }
    
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO {
        if let error = errorToThrow { throw error }
        guard let h2h = mockH2H else { throw AppException.noData }
        return h2h
    }

    func getFixtures(sport: String, leagueId: String, from: String, to: String) async throws -> [MatchDTO] {
        if let error = errorToThrow { throw error }
        return mockFixtures
    }

    func getLiveScores(sport: String) async throws -> [MatchDTO] {
        if let error = errorToThrow { throw error }
        return mockLiveScores
    }

    func getMatchDetails(sport: SportType, matchId: String) async throws -> MatchDTO {
        if let error = errorToThrow { throw error }
        guard let details = mockMatchDetails else { throw AppException.noData }
        return details
    }
}
