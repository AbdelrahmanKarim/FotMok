//
//  DataSourceModule.swift
//  FotMoc
//

import Foundation
import Factory

extension Container {
    
    var leagueLocalDataSource: Factory<LeagueLocalDataSource> {
        self { LeagueLocalDataSourceImpl() }
    }
    
    var leagueRemoteDataSource: Factory<LeagueRemoteDataSource> {
        self { LeagueRemoteDataSourceImpl(service: self.leagueService()) }
    }
    
    var matchRemoteDataSource: Factory<MatchRemoteDataSource> {
        self { MatchRemoteDataSourceImpl(service: self.matchService()) }
    }
    
    var playerRemoteDataSource: Factory<PlayerRemoteDataSource> {
        self { PlayerRemoteDataSourceImpl(service: self.playerService()) }
    }
    
    var teamRemoteDataSource: Factory<TeamRemoteDataSource> {
        self { TeamRemoteDataSourceImpl(service: self.teamService()) }
    }
}
