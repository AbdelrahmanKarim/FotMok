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
    
}
