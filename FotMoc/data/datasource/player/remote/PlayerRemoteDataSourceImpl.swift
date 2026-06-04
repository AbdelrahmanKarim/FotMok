//
//  PlayerRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

class PlayerRemoteDataSourceImpl: PlayerRemoteDataSource {
    private let service: PlayerService
        
    init(service: PlayerService) {
        self.service = service
    }
    
    func getTopScorers(sport: String, leagueId: String) async throws -> [TopScorerDTO] {
        do {
            let res = try await service.fetchTopScorers(sport: sport, leagueId: leagueId)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch { throw AppException.map(error) }
    }
}
