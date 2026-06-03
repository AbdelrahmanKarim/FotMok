//
//  LeagueRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import RxSwift
class LeagueRemoteDataSourceImpl: LeagueRemoteDataSource {
    private let service: LeagueService
        
        init(service: LeagueService) {
            self.service = service
        }
    
    func getLeagues(sport: SportType) async throws -> [LeagueDTO] {
            
            let dtoResult = try await service.fetchLeagues(sport: sport.rawValue)
        
            guard let leagueDTOs = dtoResult.result else {
                return []
            }
            return leagueDTOs
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
                        observer.onError(error)
                    }
                }
                return Disposables.create {
                    task.cancel()
                }
            }
           
            .map { dtos in
                dtos.filter { dto in
                    dto.leagueName.lowercased().contains(cleanQuery.lowercased())
                }
            }
        }
}
