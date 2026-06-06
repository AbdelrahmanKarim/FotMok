//
//  LeagueRepoImplTest.swift
//  FotMocTests
//
//  Created by Alaa Ayman on 06/06/2026.
//


import XCTest
import RxSwift

@testable import FotMoc

final class LeagueRepositoryImplTests: XCTestCase {
    var sut: LeagueRepositoryImpl!
    var mockRemote: MockLeagueRemoteDataSource!
    var mockLocal: MockLeagueLocalDataSource!
    var mockSportProvider: MockCurrentSportProvider!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockRemote = MockLeagueRemoteDataSource()
        mockLocal = MockLeagueLocalDataSource()
        mockSportProvider = MockCurrentSportProvider()
        disposeBag = DisposeBag()
        
        sut = LeagueRepositoryImpl(
            remoteDataSource: mockRemote,
            localDataSource: mockLocal,
            sportProvider: mockSportProvider
        )
    }

    override func tearDown() {
        sut = nil
        mockRemote = nil
        mockLocal = nil
        mockSportProvider = nil
        disposeBag = nil
        super.tearDown()
    }

    func test_getLeagueDetails_whenMatchFound_returnsMappedLeague() async throws {
        // Arrange
        mockSportProvider.mockSelectedSport = .football
        
        let testDTO = LeagueDTO(
            leagueKey: 152,
            leagueName: "Premier League",
            countryKey: nil,       // Added parameter
            countryName: nil,      // Added parameter
            leagueLogo: nil,       // Added parameter
            countryLogo: nil       // Added parameter
        )
        mockRemote.mockLeagues = [testDTO]

        // Act
        let result = try await sut.getLeagueDetails(leagueId: "152")

        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result.id, "152")
    }

    func test_getLeagueDetails_whenNoMatch_throwsNoDataException() async {
        // Arrange
        mockSportProvider.mockSelectedSport = .football
        
        let nonMatchingDTO = LeagueDTO(
            leagueKey: 99,
            leagueName: "Other League",
            countryKey: nil,       // Added parameter
            countryName: nil,      // Added parameter
            leagueLogo: nil,       // Added parameter
            countryLogo: nil       // Added parameter
        )
        mockRemote.mockLeagues = [nonMatchingDTO]

        // Act & Assert
        do {
            _ = try await sut.getLeagueDetails(leagueId: "152")
            XCTFail("Expected AppException.noData error to be thrown")
        } catch AppException.noData {
            // Success path
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
  
}
