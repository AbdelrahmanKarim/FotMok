//
//  DatasourceMocks.swift
//  FotMocTests
//
//  Created by Alaa Ayman on 06/06/2026.
//
import Foundation
@testable import FotMoc


class DummyNetworkManager: NetworkManager {}

class MockLeagueService: LeagueService {
  
    var mockLeaguesResult: ResultDTO<[LeagueDTO]>?
    var mockStandingsResult: ResultDTO<StandingDTO>?
    var errorToThrow: Error?
    
    init() {
       
        super.init(network: DummyNetworkManager())
    }

    override func fetchLeagues(sport: String) async throws -> ResultDTO<[LeagueDTO]> {
        if let error = errorToThrow { throw error }
        guard let result = mockLeaguesResult else {
            throw AppException.noData
        }
        return result
    }

    override func fetchStandings(sport: String, leagueId: String) async throws -> ResultDTO<StandingDTO> {
        if let error = errorToThrow { throw error }
        guard let result = mockStandingsResult else {
            throw AppException.noData
        }
        return result
    }

    override func fetchTennisStandings(leagueId: String) async throws -> ResultDTO<StandingDTO> {
        if let error = errorToThrow { throw error }
        guard let result = mockStandingsResult else {
            throw AppException.noData
        }
        return result
    }
}
