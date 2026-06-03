//
//  LeagueMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

extension LeagueDTO {
    func toEntity(sport: SportType = .football) -> League {
        let country = Country(
            id: String(countryKey),
            name: countryName,
            flagUrl: countryLogo != nil ? URL(string: countryLogo!) : nil
        )
        
        return League(
            id: String(leagueKey),
            name: leagueName,
            logoUrl: URL(string: leagueLogo),
            sport: sport,
            country: country,
            season: "", 
            sportContext: .teamSport
        )
    }
}
