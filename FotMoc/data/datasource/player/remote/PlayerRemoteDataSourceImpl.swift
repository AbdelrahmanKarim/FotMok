//
//  PlayerRemoteDataSourceImpl.swift
//  FotMoc
//

import Foundation

class PlayerRemoteDataSourceImpl: PlayerRemoteDataSource {
    private let service: PlayerService
        
    init(service: PlayerService) {
        self.service = service
    }

    func getPlayerDetails(sport: SportType, playerId: String) async throws -> PlayerDTO {
        do {
            let response = try await service.fetchPlayerDetails(sport: sport.rawValue, playerId: playerId)
            guard let players = response.result, !players.isEmpty else {
                throw AppException.notFound
            }
            let activeProfile = players.first(where: { $0.teamName != nil && !($0.teamName!.isEmpty) }) ?? players.first!
            return activeProfile
        } catch {
            throw AppException.map(error)
        }
    }
    
    func getTopScorers(sport: String, leagueId: String) async throws -> [TopScorerDTO] {
        do {
            let res = try await service.fetchTopScorers(sport: sport, leagueId: leagueId)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }
}
