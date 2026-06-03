//
//  DataSourceModule.swift
//  FotMoc
//

import Foundation
import Factory
import CoreData
import UIKit
extension Container {
    
    var activeLeagueId: Factory<String> {
            self { "0" } 
        }
    var activeSport: Factory<SportType> {
        self { .football }
    }
    var managedObjectContext: Factory<NSManagedObjectContext> {
        self {
        MainActor.assumeIsolated {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                return appDelegate.persistentContainer.viewContext
            }
        }.singleton
    }
    var favouriteDAO: Factory<FavoritesDAOProtocol> {
            self { FavouriteDAO(context: self.managedObjectContext()) }
    }
    var leagueLocalDataSource: Factory<LeagueLocalDataSource> {
        self { LeagueLocalDataSourceImpl(dao: self.favouriteDAO() , context: self.managedObjectContext()) }
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
        self { TeamRemoteDataSourceImpl(service: self.teamService() , leagueService: self.leagueService()) }
    }
}
