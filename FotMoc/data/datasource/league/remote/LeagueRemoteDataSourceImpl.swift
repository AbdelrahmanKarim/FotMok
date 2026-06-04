//
//  LeagueRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation


class LeagueRemoteDataSourceImpl: LeagueRemoteDataSource {
    private let service: LeagueService
        
    init(service: LeagueService) {
        self.service = service
    }
    
    
        
    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total] {
        do {
            let res = try await service.fetchStandings(sport: sport, leagueId: leagueId)
            guard res.success == 1, let result = res.result?.total else { throw AppException.noData }
            return result
        } catch { throw AppException.map(error) }
    }
}
