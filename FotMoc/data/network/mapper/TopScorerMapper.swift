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
            id: String(playerKey ?? 0),
            name: playerName ?? "Unknown",
            imageUrl: nil, nationality: nil, age: nil,
            sportDetails: .teamSport(teamId: String(teamKey ?? 0), position: "Attacker")
        )
        return TopScorer(
            rank: playerPlace ?? 0,
            player: player,
            goals: goals ?? 0,
            assists: assists ?? 0,
            teamName: teamName ?? ""
        )
    }
}
