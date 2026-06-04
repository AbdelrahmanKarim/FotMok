//
//  MatchRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

class MatchRemoteDataSourceImpl: MatchRemoteDataSource {
    private let service: MatchService
        
        init(service: MatchService) {
            self.service = service
        }
    func getMatchDetails(sport: SportType, matchId: String) async throws -> MatchDTO? {
         
            let response = try await service.fetchMatchDetails(sport: sport.rawValue, matchId: matchId)
        
            guard let matches = response.result, !matches.isEmpty else {
                return nil
            }
            return matches.first
        }
    
}
