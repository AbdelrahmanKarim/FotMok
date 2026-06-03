//
//  StandingRowDTO.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

import Foundation

struct Total: Codable {
    let standingPlace: Int
    let standingPlaceType: String
    let standingTeam: String
    let standingP: Int
    let standingW: Int
    let standingD: Int
    let standingL: Int
    let standingF: Int
    let standingA: Int
    let standingGD: Int
    let standingPTS: Int
    let teamKey: Int
    let leagueKey: Int
    let leagueSeason: String
    let leagueRound: String
    let standingUpdated: String
    let fkStageKey: Int
    let stageName: String
    let teamLogo: String
    let standingLP: Int
    let standingWP: Int

    enum CodingKeys: String, CodingKey {
        case standingPlace = "standing_place"
        case standingPlaceType = "standing_place_type"
        case standingTeam = "standing_team"
        case standingP = "standing_P"
        case standingW = "standing_W"
        case standingD = "standing_D"
        case standingL = "standing_L"
        case standingF = "standing_F"
        case standingA = "standing_A"
        case standingGD = "standing_GD"
        case standingPTS = "standing_PTS"
        case teamKey = "team_key"
        case leagueKey = "league_key"
        case leagueSeason = "league_season"
        case leagueRound = "league_round"
        case standingUpdated = "standing_updated"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case teamLogo = "team_logo"
        case standingLP = "standing_LP"
        case standingWP = "standing_WP"
    }
}

struct Home: Codable {
    let standingPlace: Int
    let standingPlaceType: String?
    let standingTeam: String
    let standingP: Int
    let standingW: Int
    let standingD: Int
    let standingL: Int
    let standingF: Int
    let standingA: Int
    let standingGD: Int
    let standingPTS: Int
    let teamKey: Int
    let leagueKey: Int
    let leagueSeason: String
    let leagueRound: String
    let standingUpdated: String
    let fkStageKey: Int
    let stageName: String
    let teamLogo: String
    let standingLP: Int
    let standingWP: Int

    enum CodingKeys: String, CodingKey {
        case standingPlace = "standing_place"
        case standingPlaceType = "standing_place_type"
        case standingTeam = "standing_team"
        case standingP = "standing_P"
        case standingW = "standing_W"
        case standingD = "standing_D"
        case standingL = "standing_L"
        case standingF = "standing_F"
        case standingA = "standing_A"
        case standingGD = "standing_GD"
        case standingPTS = "standing_PTS"
        case teamKey = "team_key"
        case leagueKey = "league_key"
        case leagueSeason = "league_season"
        case leagueRound = "league_round"
        case standingUpdated = "standing_updated"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case teamLogo = "team_logo"
        case standingLP = "standing_LP"
        case standingWP = "standing_WP"
    }
}

struct Away: Codable {
    let standingPlace: Int
    let standingPlaceType: String?
    let standingTeam: String
    let standingP: Int
    let standingW: Int
    let standingD: Int
    let standingL: Int
    let standingF: Int
    let standingA: Int
    let standingGD: Int
    let standingPTS: Int
    let teamKey: Int
    let leagueKey: Int
    let leagueSeason: String
    let leagueRound: String
    let standingUpdated: String
    let fkStageKey: Int
    let stageName: String
    let teamLogo: String
    let standingLP: Int
    let standingWP: Int

    enum CodingKeys: String, CodingKey {
        case standingPlace = "standing_place"
        case standingPlaceType = "standing_place_type"
        case standingTeam = "standing_team"
        case standingP = "standing_P"
        case standingW = "standing_W"
        case standingD = "standing_D"
        case standingL = "standing_L"
        case standingF = "standing_F"
        case standingA = "standing_A"
        case standingGD = "standing_GD"
        case standingPTS = "standing_PTS"
        case teamKey = "team_key"
        case leagueKey = "league_key"
        case leagueSeason = "league_season"
        case leagueRound = "league_round"
        case standingUpdated = "standing_updated"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case teamLogo = "team_logo"
        case standingLP = "standing_LP"
        case standingWP = "standing_WP"
    }
}

struct StandingDTO: Codable {
    let total: [Total]
    let home: [Home]
    let away: [Away]
}

