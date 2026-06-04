//
//  FavouriteMapper.swift
//  FotMoc
//
//  Created by Alaa Ayman on 03/06/2026.
//
import Foundation
import CoreData
import UIKit

extension League {
    
    func toEntity(in context: NSManagedObjectContext) -> LeagueEntity {
        
        let entity = LeagueEntity(context: context)
        
       
        entity.setValue(self.id, forKey: "leagueId")
        entity.setValue(self.name, forKey: "leagueName")
        entity.setValue(self.logoUrl?.absoluteString, forKey: "leagueLogo")
        entity.setValue(self.sport.rawValue, forKey: "sport")
        entity.setValue(self.country?.name, forKey: "countryName")
        
        return entity
    }
}
extension LeagueEntity {
    
    
    func toDomainEntity() -> League {
        
     
        let id = self.value(forKey: "leagueId") as? String ?? ""
        let name = self.value(forKey: "leagueName") as? String ?? "Unknown"
        let logoString = self.value(forKey: "leagueLogo") as? String
        let sportString = self.value(forKey: "sport") as? String ?? "football"
        let countryName = self.value(forKey: "countryName") as? String
        
     
        var domainCountry: Country? = nil
        if let cName = countryName {
            domainCountry = Country(id: "", name: cName , flagUrl: nil)
        }
        
    
        return League(
            id: id,
            name: name,
            logoUrl: logoString != nil ? URL(string: logoString!) : nil,
            sport: SportType(rawValue: sportString) ?? .football,
            country: domainCountry,
            season: "",
            sportContext: .teamSport
        )
    }
}
