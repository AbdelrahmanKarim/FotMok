//
//  MatchRepoImplTest.swift
//  FotMoc
//
//  Created by Alaa Ayman on 06/06/2026.
//

import XCTest
@testable import FotMoc

final class MatchRepositoryImplTests: XCTestCase {
    var sut: MatchRepositoryImpl!
    var mockRemote: MockMatchRemoteDataSource!
    var mockSportProvider: MockCurrentSportProvider!

    override func setUp() {
        super.setUp()
        mockRemote = MockMatchRemoteDataSource()
        mockSportProvider = MockCurrentSportProvider()
        sut = MatchRepositoryImpl(remoteDataSource: mockRemote, sportProvider: mockSportProvider)
    }

    override func tearDown() {
        sut = nil
        mockRemote = nil
        mockSportProvider = nil
        super.tearDown()
    }

    func test_getLeagueLatestMatches_whenTennis_usesSevenYearLookbackWindow() async throws {
     
        mockSportProvider.mockSelectedSport = .tennis
        
    
        let mockMatch = MatchDTO(
            eventKey: 301, eventDate: "2025-05-10", eventTime: nil,
            eventHalftimeResult: nil, eventFinalResult: "6-4 6-2",
            eventFtResult: nil, eventPenaltyResult: nil, eventStatus: "Finished",
            countryName: nil, leagueName: "Wimbledon", leagueKey: 44,
            leagueRound: nil, leagueSeason: nil, eventLive: nil,
            eventStadium: nil, eventReferee: nil, eventCountryKey: nil,
            leagueLogo: nil, countryLogo: nil, eventHomeFormation: nil, eventAwayFormation: nil,
            fkStageKey: nil, stageName: nil, leagueGroup: nil,
            eventHomeTeam: nil, homeTeamKey: nil, eventAwayTeam: nil, awayTeamKey: nil,
            homeTeamLogo: nil, awayTeamLogo: nil,
            eventFirstPlayer: "Federer", firstPlayerKey: 1, eventSecondPlayer: "Nadal", secondPlayerKey: 2,
            eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventGameResult: nil, scores: nil,
            goalscorers: nil, substitutes: nil, cards: nil, vars: nil, lineups: nil, statistics: nil
        )
        mockRemote.mockFixtures = [mockMatch]

     
        let matches = try await sut.getLeagueLatestMatches(leagueId: "44")

  
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches.first?.id, "301")
    }

    func test_getLeagueLatestMatches_whenFootball_usesSixtyDayLookbackWindow() async throws {
     
        mockSportProvider.mockSelectedSport = .football
        let mockMatch = MatchDTO(
            eventKey: 302, eventDate: "2026-06-01", eventTime: nil,
            eventHalftimeResult: nil, eventFinalResult: "1-1",
            eventFtResult: nil, eventPenaltyResult: nil, eventStatus: "Finished",
            countryName: nil, leagueName: "EPL", leagueKey: 152,
            leagueRound: nil, leagueSeason: nil, eventLive: nil,
            eventStadium: nil, eventReferee: nil, eventCountryKey: nil,
            leagueLogo: nil, countryLogo: nil, eventHomeFormation: nil, eventAwayFormation: nil,
            fkStageKey: nil, stageName: nil, leagueGroup: nil,
            eventHomeTeam: "Chelsea", homeTeamKey: 11, eventAwayTeam: "Spurs", awayTeamKey: 12,
            homeTeamLogo: nil, awayTeamLogo: nil,
            eventFirstPlayer: nil, firstPlayerKey: nil, eventSecondPlayer: nil, secondPlayerKey: nil,
            eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventGameResult: nil, scores: nil,
            goalscorers: nil, substitutes: nil, cards: nil, vars: nil, lineups: nil, statistics: nil
        )
        mockRemote.mockFixtures = [mockMatch]

    
        let matches = try await sut.getLeagueLatestMatches(leagueId: "152")

    
        XCTAssertEqual(matches.count, 1)
    }
}
