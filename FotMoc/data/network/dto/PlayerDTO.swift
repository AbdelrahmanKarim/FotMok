//
//  PlayerDTO.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import Foundation

struct PlayerDTO: Codable {
    let playerKey: Int
    let playerName: String
    let playerNumber: String
    let playerCountry: String
    let playerType: String
    let playerAge: String
    let playerMatchPlayed: String
    let playerGoals: String
    let playerYellowCards: String
    let playerRedCards: String
    let playerMinutes: String
    let playerInjured: String
    let playerSubstituteOut: String
    let playerSubstitutesOnBench: String
    let playerAssists: String
    let playerIsCaptain: String
    let playerShotsTotal: String
    let playerGoalsConceded: String
    let playerFoulsCommited: String
    let playerTackles: String
    let playerBlocks: String
    let playerCrossesTotal: String
    let playerInterceptions: String
    let playerClearances: String
    let playerDispossesed: String
    let playerSaves: String
    let playerInsideBoxSaves: String
    let playerDuelsTotal: String
    let playerDuelsWon: String
    let playerDribbleAttempts: String
    let playerDribbleSucc: String
    let playerPenComm: String
    let playerPenWon: String
    let playerPenScored: String
    let playerPenMissed: String
    let playerPasses: String
    let playerPassesAccuracy: String
    let playerKeyPasses: String
    let playerWoordworks: String
    let playerRating: String
    let teamName: String?
    let teamKey: Int
    let playerImage: String?

    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerCountry = "player_country"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerGoals = "player_goals"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards = "player_red_cards"
        case playerMinutes = "player_minutes"
        case playerInjured = "player_injured"
        case playerSubstituteOut = "player_substitute_out"
        case playerSubstitutesOnBench = "player_substitutes_on_bench"
        case playerAssists = "player_assists"
        case playerIsCaptain = "player_is_captain"
        case playerShotsTotal = "player_shots_total"
        case playerGoalsConceded = "player_goals_conceded"
        case playerFoulsCommited = "player_fouls_commited"
        case playerTackles = "player_tackles"
        case playerBlocks = "player_blocks"
        case playerCrossesTotal = "player_crosses_total"
        case playerInterceptions = "player_interceptions"
        case playerClearances = "player_clearances"
        case playerDispossesed = "player_dispossesed"
        case playerSaves = "player_saves"
        case playerInsideBoxSaves = "player_inside_box_saves"
        case playerDuelsTotal = "player_duels_total"
        case playerDuelsWon = "player_duels_won"
        case playerDribbleAttempts = "player_dribble_attempts"
        case playerDribbleSucc = "player_dribble_succ"
        case playerPenComm = "player_pen_comm"
        case playerPenWon = "player_pen_won"
        case playerPenScored = "player_pen_scored"
        case playerPenMissed = "player_pen_missed"
        case playerPasses = "player_passes"
        case playerPassesAccuracy = "player_passes_accuracy"
        case playerKeyPasses = "player_key_passes"
        case playerWoordworks = "player_woordworks"
        case playerRating = "player_rating"
        case teamName = "team_name"
        case teamKey = "team_key"
        case playerImage = "player_image"
    }
}
