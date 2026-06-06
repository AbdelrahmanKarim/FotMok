//
//  FavouriteDao.swift
//  FotMoc
//
//  Created by Alaa Ayman on 03/06/2026.
//
import Foundation
import CoreData
import UIKit

final class FavouriteDAO  : FavoritesDAOProtocol{
    
    private let context: NSManagedObjectContext
        
        init(context: NSManagedObjectContext) {
            self.context = context
        }
    
    func saveFavourite() throws {
            try context.save()
    }
    
    func fetchAllFavourites() throws -> [NSManagedObject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "LeagueEntity")
        return try context.fetch(request)
    }
    
    func deleteFavourite(id: String) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "LeagueEntity")
        request.predicate = NSPredicate(format: "leagueID == %@", id)
        
        if let objectToDelete = try context.fetch(request).first {
            context.delete(objectToDelete)
            try context.save()
        }
    }
}




