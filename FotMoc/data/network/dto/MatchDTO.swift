//
//  MatchDTO.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

import Foundation

struct MatchDTO: Codable {
    let eventKey: Int?
    let eventDate: String?
    let eventTime: String?
    let eventHomeTeam: String?
    let homeTeamKey: Int?
    let eventAwayTeam: String?
    let awayTeamKey: Int?
    let eventHalftimeResult: String?
    let eventFinalResult: String?
    let eventFtResult: String?
    let eventPenaltyResult: String?
    let eventStatus: String?
    let countryName: String?
    let leagueName: String?
    let leagueKey: Int?
    let leagueRound: String?
    let leagueSeason: String?
    let eventLive: String?
    let eventStadium: String?
    let eventReferee: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventCountryKey: Int?
    let leagueLogo: String?
    let countryLogo: String?
    let eventHomeFormation: String?
    let eventAwayFormation: String?
    let fkStageKey: Int?
    let stageName: String?
    let leagueGroup: String?
    
    let goalscorers: [Goalscorers]?
    let substitutes: [Substitutes]?
    let cards: [Cards]?
    let vars: Vars?
    let lineups: Lineups?
    let statistics: [Statistics]?

    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventHomeTeam = "event_home_team"
        case homeTeamKey = "home_team_key"
        case eventAwayTeam = "event_away_team"
        case awayTeamKey = "away_team_key"
        case eventHalftimeResult = "event_halftime_result"
        case eventFinalResult = "event_final_result"
        case eventFtResult = "event_ft_result"
        case eventPenaltyResult = "event_penalty_result"
        case eventStatus = "event_status"
        case countryName = "country_name"
        case leagueName = "league_name"
        case leagueKey = "league_key"
        case leagueRound = "league_round"
        case leagueSeason = "league_season"
        case eventLive = "event_live"
        case eventStadium = "event_stadium"
        case eventReferee = "event_referee"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventCountryKey = "event_country_key"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case eventHomeFormation = "event_home_formation"
        case eventAwayFormation = "event_away_formation"
        case fkStageKey = "fk_stage_key"
        case stageName = "stage_name"
        case leagueGroup = "league_group"
        case goalscorers
        case substitutes
        case cards
        case vars
        case lineups
        case statistics
    }
}

struct Goalscorers: Codable {
    let time: String?
    let homeScorer: String?
    let homeScorerId: String?
    let homeAssist: String?
    let homeAssistId: String?
    let score: String?
    let awayScorer: String?
    let awayScorerId: String?
    let awayAssist: String?
    let awayAssistId: String?
    let info: String?
    let infoTime: String?

    enum CodingKeys: String, CodingKey {
        case time
        case homeScorer = "home_scorer"
        case homeScorerId = "home_scorer_id"
        case homeAssist = "home_assist"
        case homeAssistId = "home_assist_id"
        case score
        case awayScorer = "away_scorer"
        case awayScorerId = "away_scorer_id"
        case awayAssist = "away_assist"
        case awayAssistId = "away_assist_id"
        case info
        case infoTime = "info_time"
    }
}

struct Substitutes: Codable {
    let time: String?
    let score: String?
    let infoTime: String?
    let info: String?
    let homeAssist: String?
    let awayAssist: String?
    
    let homeScorer: FlexibleSubstitution?
    let awayScorer: FlexibleSubstitution?

    enum CodingKeys: String, CodingKey {
        case time
        case score
        case infoTime = "info_time"
        case info
        case homeAssist = "home_assist"
        case awayAssist = "away_assist"
        case homeScorer = "home_scorer"
        case awayScorer = "away_scorer"
    }
}

struct SubstitutionDetail: Codable {
    let playerIn: String?
    let playerOut: String?
    let inId: Int?
    let outId: Int?

    enum CodingKeys: String, CodingKey {
        case playerIn = "in"
        case playerOut = "out"
        case inId = "in_id"
        case outId = "out_id"
    }
}

enum FlexibleSubstitution: Codable {
    case detail(SubstitutionDetail)
    case emptyArray

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let detail = try? container.decode(SubstitutionDetail.self) {
            self = .detail(detail)
            return
        }
        
        if let array = try? container.decode([String].self), array.isEmpty {
            self = .emptyArray
            return
        }
        
        throw DecodingError.typeMismatch(
            FlexibleSubstitution.self,
            DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Substitution Object or Empty Array")
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .detail(let detail):
            try container.encode(detail)
        case .emptyArray:
            try container.encode([String]())
        }
    }
}

struct Cards: Codable {
    let time: String?
    let homeFault: String?
    let card: String?
    let awayFault: String?
    let info: String?
    let homePlayerId: String?
    let awayPlayerId: String?
    let infoTime: String?

    enum CodingKeys: String, CodingKey {
        case time
        case homeFault = "home_fault"
        case card
        case awayFault = "away_fault"
        case info
        case homePlayerId = "home_player_id"
        case awayPlayerId = "away_player_id"
        case infoTime = "info_time"
    }
}

struct Vars: Codable {
    let homeTeam: [VarDetail]?
    let awayTeam: [VarDetail]?

    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

struct VarDetail: Codable {
    let varPlayerName: String?
    let varMinute: String?
    let varPlayerId: Int?
    let varType: String?
    let varEventDecision: String?
    let varDecision: String?

    enum CodingKeys: String, CodingKey {
        case varPlayerName = "var_player_name"
        case varMinute = "var_minute"
        case varPlayerId = "var_player_id"
        case varType = "var_type"
        case varEventDecision = "var_event_decision"
        case varDecision = "var_decision"
    }
}

struct Lineups: Codable {
    let homeTeam: TeamLineup?
    let awayTeam: TeamLineup?

    enum CodingKeys: String, CodingKey {
        case homeTeam = "home_team"
        case awayTeam = "away_team"
    }
}

struct TeamLineup: Codable {
    let startingLineups: [LineupPlayer]?
    let substitutes: [LineupPlayer]?
    let coaches: [Coach]?
    let missingPlayers: [LineupPlayer]?

    enum CodingKeys: String, CodingKey {
        case startingLineups = "starting_lineups"
        case substitutes
        case coaches
        case missingPlayers = "missing_players"
    }
}

struct LineupPlayer: Codable {
    let player: String?
    let playerNumber: Int?
    let playerPosition: Int?
    let playerCountry: String?
    let playerKey: Int?
    let infoTime: String?

    enum CodingKeys: String, CodingKey {
        case player
        case playerNumber = "player_number"
        case playerPosition = "player_position"
        case playerCountry = "player_country"
        case playerKey = "player_key"
        case infoTime = "info_time"
    }
}

struct Coach: Codable {
    let coache: String?
    let coacheCountry: String?

    enum CodingKeys: String, CodingKey {
        case coache
        case coacheCountry = "coache_country"
    }
}

struct Statistics: Codable {
    let type: String?
    let home: String?
    let away: String?
}
