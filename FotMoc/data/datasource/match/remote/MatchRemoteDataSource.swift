//
//  MatchRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol MatchRemoteDataSource {
    func getMatchDetails(sport: SportType, matchId: String) async throws -> MatchDTO?
}
