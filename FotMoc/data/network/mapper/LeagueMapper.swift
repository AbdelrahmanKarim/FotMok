//
//  LeagueMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

//
//  LeagueMapper.swift
//  FotMoc
//

import Foundation

extension LeagueDTO {
    func toEntity(sport: SportType = .football) -> League {
        let country = Country(
            id: String(countryKey ?? 0),
            name: countryName ?? "Unknown",
            flagUrl: countryLogo != nil ? URL(string: countryLogo!) : nil
        )
        
        return League(
            id: String(leagueKey ?? 0),
            name: leagueName ?? "Unknown",
            logoUrl: leagueLogo != nil ? URL(string: leagueLogo!) : nil,
            sport: sport,
            country: country,
            season: "",
            sportContext: .teamSport
        )
    }
}
