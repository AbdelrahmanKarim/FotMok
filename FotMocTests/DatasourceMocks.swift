//
//  DatasourceMocks.swift
//  FotMocTests
//
//  Created by Alaa Ayman on 06/06/2026.
//
import Foundation
@testable import FotMoc

// If NetworkManager is a class or protocol, create a simple dummy instance to satisfy the initializer
class DummyNetworkManager: NetworkManager {}

class MockLeagueService: LeagueService {
    // Variables to control mock results
    var mockLeaguesResult: ResultDTO<[LeagueDTO]>?
    var mockStandingsResult: ResultDTO<StandingDTO>?
    var errorToThrow: Error?
    
    init() {
        // Pass dummy networking reference to avoid making real API connections
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
