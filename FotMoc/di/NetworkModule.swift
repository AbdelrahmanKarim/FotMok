//
//  DIContainer.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//


import Foundation
import Factory

extension Container {
    
    var networkManager: Factory<NetworkManager> {
        self { NetworkManager() }.singleton
    }
    
    var leagueService: Factory<LeagueService> {
        self { LeagueService(network: self.networkManager()) }
    }
    
    var matchService: Factory<MatchService> {
        self { MatchService(network: self.networkManager()) }
    }
    
    var playerService: Factory<PlayerService> {
        self { PlayerService(network: self.networkManager()) }
    }
    
    var teamService: Factory<TeamService> {
        self { TeamService(network: self.networkManager()) }
    }
}
