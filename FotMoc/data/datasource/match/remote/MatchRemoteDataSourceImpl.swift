//
//  MatchRemoteDataSourceImpl.swift
//  FotMoc
//

import Foundation

class MatchRemoteDataSourceImpl: MatchRemoteDataSource {
    private let service: MatchService
        
    init(service: MatchService) {
        self.service = service
    }

    func getMatchDetails(sport: SportType, matchId: String) async throws -> MatchDTO {
        do {
            let response = try await service.fetchMatchDetails(sport: sport.rawValue, matchId: matchId)
            guard let matches = response.result, !matches.isEmpty, let match = matches.first else {
                throw AppException.notFound
            }
            return match
        } catch {
            throw AppException.map(error)
        }
    }
    
    func getFixtures(sport: String, leagueId: String?, from: String, to: String) async throws -> [MatchDTO] {
        do {
            let res = try await service.fetchFixtures(sport: sport,  leagueId: leagueId, from: from, to: to)
            guard res.success == 1 else { throw AppException.noData }
            return res.result ?? []
        } catch {
            throw AppException.map(error)
        }
    }
        
    func getLiveScores(sport: String) async throws -> [MatchDTO] {
        do {
            let res = try await service.fetchLiveScores(sport: sport)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }
        
    func getH2H(sport: String, firstTeamId: String, secondTeamId: String) async throws -> H2HResponseDTO {
        do {
            let res = try await service.fetchH2H(sport: sport, firstTeamId: firstTeamId, secondTeamId: secondTeamId)
            guard res.success == 1, let result = res.result else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }
}
