//
//  TopScorerMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

extension TopScorerDTO {
    func toEntity() -> TopScorer {
        let player = Player(
            id: String(playerKey),
            name: playerName,
            imageUrl: nil,
            nationality: nil,
            age: nil,
            sportDetails: .teamSport(teamId: String(teamKey), position: "Attacker")
        )
        
        return TopScorer(
            rank: playerPlace,
            player: player,
            goals: goals,
            assists: Int(assists ?? "0")
        )
    }
}
