//
//  LeagueRemoteDataSourceImpl.swift
//  FotMoc
//

import Foundation
import RxSwift

class LeagueRemoteDataSourceImpl: LeagueRemoteDataSource {
    private let service: LeagueService
        
    init(service: LeagueService) {
        self.service = service
    }
    
    func getLeagues(sport: SportType) async throws -> [LeagueDTO] {
        do {
            let response = try await service.fetchLeagues(sport: sport.rawValue)
            guard let leagueDTOs = response.result else { throw AppException.noData }
            return leagueDTOs
        } catch {
            throw AppException.map(error)
        }
    }
    
    func searchLeagues(sport: SportType, query: String) -> Observable<[LeagueDTO]> {
        let cleanQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanQuery.isEmpty {
            return Observable.just([])
        }
        
        return Observable.create { [weak self] observer in
            let task = Task {
                do {
                    let dtos = try await self?.getLeagues(sport: sport) ?? []
                    observer.onNext(dtos)
                    observer.onCompleted()
                } catch {
                    observer.onError(AppException.map(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
        .map { dtos in
            dtos.filter { dto in
                (dto.leagueName ?? "").lowercased().contains(cleanQuery.lowercased())
            }
        }
    }
        
    func getLeagueTableStandings(sport: String, leagueId: String) async throws -> [Total] {
        do {
            let res = try await service.fetchStandings(sport: sport, leagueId: leagueId)
            guard res.success == 1, let result = res.result?.total else { throw AppException.noData }
            return result
        } catch {
            throw AppException.map(error)
        }
    }
}
