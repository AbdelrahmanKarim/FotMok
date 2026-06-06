//
//  FavouriteMapper.swift
//  FotMoc
//

import Foundation
import CoreData
import UIKit

extension League {
    func toEntity(in context: NSManagedObjectContext) -> LeagueEntity {
        let entity = LeagueEntity(context: context)
        
        entity.leagueID = self.id
        entity.leagueName = self.name
        entity.leagueLogo = self.logoUrl?.absoluteString
        entity.sportType = self.sport.rawValue
        entity.countryName = self.country?.name
        
        return entity
    }
}

extension LeagueEntity {
    func toDomainEntity() -> League {
        let id = self.leagueID ?? ""
        let name = self.leagueName ?? "Unknown"
        let logoString = self.leagueLogo
        let sportString = self.sportType ?? "football"
        let countryName = self.countryName
        
        var domainCountry: Country? = nil
        if let cName = countryName {
            domainCountry = Country(id: "", name: cName, flagUrl: nil)
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
