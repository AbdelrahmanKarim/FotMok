//
//  TopScorerDTO.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

import Foundation

struct TopScorerDTO: Codable {
    let playerPlace: Int
    let playerName: String
    let playerKey: Int
    let teamName: String
    let teamKey: Int
    let goals: Int
    let assists: String?
    let penaltyGoals: String?

    enum CodingKeys: String, CodingKey {
        case playerPlace = "player_place"
        case playerName = "player_name"
        case playerKey = "player_key"
        case teamName = "team_name"
        case teamKey = "team_key"
        case goals
        case assists
        case penaltyGoals = "penalty_goals"
    }
}

