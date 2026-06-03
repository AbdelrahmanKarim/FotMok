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
}
