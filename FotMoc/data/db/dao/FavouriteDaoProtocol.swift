//
//  FavouriteDaoProtocol.swift
//  FotMoc
//
//  Created by Alaa Ayman on 03/06/2026.
//
import CoreData
protocol FavoritesDAOProtocol {
    func saveFavourite() throws
    func fetchAllFavourites() throws -> [NSManagedObject]
    func deleteFavourite(id: String) throws
}

