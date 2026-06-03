//
//  TeamMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//
import Foundation

extension TeamDTO {
    func toEntity(sport: SportType = .football) -> Team {
        return Team(
            id: String(teamKey),
            name: teamName,
            logoUrl: URL(string: teamLogo),
            sport: sport,
            countryName: nil,
            foundedYear: nil,
            description: nil
        )
    }
}
extension Players {
    func toEntity(teamId: String) -> Player {
        return Player(
            id: String(playerKey),
            name: playerName,
            imageUrl: URL(string: playerImage),
            nationality: playerCountry,
            age: Int(playerAge),
            sportDetails: .teamSport(teamId: teamId, position: playerType)
        )
    }
}
