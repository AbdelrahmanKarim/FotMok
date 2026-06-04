//
//  TeamMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//
//
//  TeamMapper.swift
//  FotMoc
//

import Foundation

extension TeamDTO {
    func toEntity(sport: SportType = .football) -> Team {
        return Team(
            id: String(teamKey ?? 0),
            name: teamName ?? "Unknown",
            logoUrl: teamLogo != nil ? URL(string: teamLogo!) : nil,
            sport: sport,
            countryName: nil,
            foundedYear: nil,
            description: nil
        )
    }
}

extension Players {
    func toEntity(teamId: String) -> Player {
        var validUrl: URL? = nil
        if let img = playerImage, !img.isEmpty {
            validUrl = URL(string: img)
        }
        return Player(
            id: String(playerKey ?? 0),
            name: playerName ?? "Unknown",
            imageUrl: validUrl,
            nationality: playerCountry,
            age: Int(playerAge ?? "0"),
            sportDetails: .teamSport(teamId: teamId, position: playerType ?? "Unknown")
        )
    }
}
