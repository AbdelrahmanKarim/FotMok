//
//  TeamRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

class TeamRemoteDataSourceImpl: TeamRemoteDataSource {
    private let service: TeamService
        
        init(service: TeamService) {
            self.service = service
        }
}
