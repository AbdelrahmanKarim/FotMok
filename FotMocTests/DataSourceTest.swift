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
    
  
    
    func test_getLeagues_whenResponseContainsResult_returnsLeagues() async throws {
    
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

        mockService.mockLeaguesResult = ResultDTO(success: 1, result: expectedLeagues)
        
  
        let leagues = try await sut.getLeagues(sport: .football)
        
    
        XCTAssertEqual(leagues.count, 1)
        XCTAssertEqual(leagues.first?.leagueName, "Premier League")
    }
    
    func test_getLeagues_whenResultIsNil_throwsNoDataException() async {
     
        mockService.mockLeaguesResult = ResultDTO(success: 1, result: nil)
        
       
        do {
            _ = try await sut.getLeagues(sport: .football)
            XCTFail("Should have thrown AppException.noData")
        } catch let AppException.noData {
            // Success
        } catch {
            XCTFail("Unexpected error type thrown: \(error)")
        }
    }
    
  
    
    func test_searchLeagues_filtersResultsCorrectly() {
  
        let expectation = self.expectation(description: "Emits filtered leagues matching layout query")
        let dtos = [
            LeagueDTO(leagueKey: 1, leagueName: "La Liga", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil),
            LeagueDTO(leagueKey: 2, leagueName: "Serie A", countryKey: nil, countryName: nil, leagueLogo: nil, countryLogo: nil)
        ]
        mockService.mockLeaguesResult = ResultDTO(success: 1, result: dtos)
    
        sut.searchLeagues(sport: .football, query: "Liga")
            .subscribe(onNext: { filteredLeagues in
         
                XCTAssertEqual(filteredLeagues.count, 1)
                XCTAssertEqual(filteredLeagues.first?.leagueName, "La Liga")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0)
    }
    
}
