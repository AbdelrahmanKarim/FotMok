//
//  LeagueLocalDataSourceImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import CoreData

class LeagueLocalDataSourceImpl: LeagueLocalDataSource {
    private let dao: FavoritesDAOProtocol
    private let context: NSManagedObjectContext
            
	
    init(dao: FavoritesDAOProtocol, context: NSManagedObjectContext) {
            self.dao = dao
            self.context = context
        }
        
    
    func saveFavouriteLeague(league: League) throws {
            let _ = league.toEntity(in: context)
            try dao.saveFavourite()
        }
        
    func getFavouriteLeagues() throws -> [League] {
        let rawObjects = try dao.fetchAllFavourites()
            return rawObjects.compactMap { managedObject in
                guard let leagueEntity = managedObject as? LeagueEntity else { return nil }
                return leagueEntity.toDomainEntity()
            }
        }
        
       
    func removeFavouriteLeague(id: String) throws {
        try dao.deleteFavourite(id: id)
        }
}
