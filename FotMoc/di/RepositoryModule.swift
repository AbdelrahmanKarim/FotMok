//
//  RepositoryModule.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation
import Factory

extension Container {
    
    var leagueRepository: Factory<LeagueRepository> {
        self {
            LeagueRepositoryImpl(
                remoteDataSource: self.leagueRemoteDataSource(),
                localDataSource: self.leagueLocalDataSource()
            )
        }
    }
    
    var matchRepository: Factory<MatchRepository> {
        self { MatchRepositoryImpl(remoteDataSource: self.matchRemoteDataSource()) }
    }
    
    var playerRepository: Factory<PlayerRepository> {
        self { PlayerRepositoryImpl(remoteDataSource: self.playerRemoteDataSource()) }
    }
    
    var teamRepository: Factory<TeamRepository> {
        self { TeamRepositoryImpl(remoteDataSource: self.teamRemoteDataSource()) }
    }
}
