//
//  DataSourceTest.swift
//  FotMocTests
//
//  Created by Alaa Ayman on 06/06/2026.
//

import Foundation
import XCTest
import RxSwift
@testable import FotMoc

final class LeagueRemoteDataSourceImplTests: XCTestCase {
    var sut: LeagueRemoteDataSourceImpl!
    var mockService: MockLeagueService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockService = MockLeagueService()
        sut = LeagueRemoteDataSourceImpl(service: mockService)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - getLeagues Tests
    
    func test_getLeagues_whenResponseContainsResult_returnsLeagues() async throws {
        // Arrange
        let expectedLeagues = [
            LeagueDTO(
                leagueKey: 152,
                leagueName: "Premier League",
                countryKey: nil,
                countryName: nil,
                leagueLogo: nil,
                countryLogo: nil
            )
        ]
        // Wrap expected data into your production ResultDTO structure
        mockService.mockLeaguesResult = ResultDTO(success: 1, result: expectedLeagues)
        
        // Act
        let leagues = try await sut.getLeagues(sport: .football)
        
        // Assert
        XCTAssertEqual(leagues.count, 1)
        XCTAssertEqual(leagues.first?.leagueName, "Premier League")
    }
    
    func test_getLeagues_whenResultIsNil_throwsNoDataException() async {
        // Arrange
        mockService.mockLeaguesResult = ResultDTO(success: 1, result: nil)
        
        // Act & Assert
        do {
            _ = try await sut.getLeagues(sport: .football)
            XCTFail("Should have thrown AppException.noData")
        } catch let AppException.noData {
            // Success
        } catch {
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }
    
    // MARK: - searchLeagues Tests (RxSwift)
    
    func test_searchLeagues_filtersResultsCorrectly() {
        // Arrange
        let expectation = self.expectation(description: "Emits filtered leagues matching layout query")
        let dtos = [
            LeagueDTO(leagueKey: 1, leagueName: "La Liga", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil),
            LeagueDTO(leagueKey: 2, leagueName: "Serie A", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        ]
        mockService.mockLeaguesResult = ResultDTO(success: 1, result: dtos)
        
        // Act
        sut.searchLeagues(sport: .football, query: "Liga")
            .subscribe(onNext: { filteredLeagues in
                // Assert
                XCTAssertEqual(filteredLeagues.count, 1)
                XCTAssertEqual(filteredLeagues.first?.leagueName, "La Liga")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0)
    }
    
}
