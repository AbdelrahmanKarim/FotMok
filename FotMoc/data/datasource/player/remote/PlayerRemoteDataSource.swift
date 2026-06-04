//
//  PlayerRemoteDataSource.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol PlayerRemoteDataSource {
    func getPlayerDetails(sport: SportType, playerId: String) async throws -> PlayerDTO?
}
