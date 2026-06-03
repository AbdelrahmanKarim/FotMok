//
//  LeagueRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import RxSwift
protocol LeagueRemoteDataSource {
    func getLeagues(sport: SportType) async throws -> [LeagueDTO]
    func searchLeagues(sport: SportType, query: String) -> Observable<[LeagueDTO]>
}
