//
//  MatchRemoteDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

class MatchRemoteDataSourceImpl: MatchRemoteDataSource {
    private let service: MatchService
        
        init(service: MatchService) {
            self.service = service
        }
}
