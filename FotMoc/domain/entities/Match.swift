//
//  Match.swift
//  FotMoc
//
//  Created by Alaa Ayman on 01/06/2026.
//
import Foundation
enum Competitor {
    case team(Team)
    case player(Player)
}

struct Match {
    let id: String
    let date: Date
    let status: MatchStatus
    let leagueId: String
    let sport: SportType
    
    let homeCompetitor: Competitor
    let awayCompetitor: Competitor
    
    let genericFinalScore: String
    
  
    let sportDetails: SportMatchDetails
}

enum SportMatchDetails {
    
    case football(liveMinute: String?, details: FootballDetails)
    case basketball(liveQuarterTime: String?, details: BasketballDetails)
    case cricket(liveStatusInfo: String?, details: CricketDetails)
    case tennis(liveSetStatus: String?, details: TennisDetails)
}


struct FootballDetails {
    let homeScore: Int
    let awayScore: Int
    let halftimeScore: String?
    let events: [MatchEvent]
    let lineups: MatchLineup?
    let statistics: [MatchStatistic]
}

struct MatchEvent {
    let minute: String
    let type: EventType
    let primaryPlayerName: String
    let secondaryPlayerName: String?
    let isHomeTeam: Bool
}

struct MatchLineup {
    let homeStartingXI: [Player]
    let awayStartingXI: [Player]
    let homeSubstitutes: [Player]
    let awaySubstitutes: [Player]
}


enum MatchStatus: String {
    case notStarted
    case live
    case finished
    case postponed
    case cancelled
}

enum EventType: String {
    case goal
    case yellowCard
    case redCard
    case substitution
}


struct MatchStatistic {
    let type: String
    let homeValue: String
    let awayValue: String
}


struct BasketballDetails {
    let quarters: [QuarterScore]
    let homePlayerStats: [BasketballPlayerStat]
    let awayPlayerStats: [BasketballPlayerStat]
}

struct QuarterScore {
    let quarterName: String
    let homeScore: Int
    let awayScore: Int
}

struct BasketballPlayerStat {
    let playerId: String
    let playerName: String
    let points: Int
    let assists: Int
    let rebounds: Int
    let steals: Int
    let blocks: Int
    let minutesPlayed: String
}



struct CricketDetails {
    let tossResult: String?
    let matchStatusInfo: String?
    let innings: [CricketInning]
}

struct CricketInning {
    let name: String
    let runs: Int
    let wickets: Int
    let overs: Double
    let battingScorecard: [BatsmanStat]
}

struct BatsmanStat {
    let playerName: String
    let status: String
    let runs: Int
    let ballsFaced: Int
    let fours: Int
    let sixes: Int
    let strikeRate: Double
}


struct TennisDetails {
    let sets: [TennisSetScore]
    let currentServer: Competitor?
    let currentPointScore: String?
    let pointByPointHistory: [TennisGameHistory]
}

struct TennisSetScore {
    let setNumber: Int
    let firstPlayerScore: Int
    let secondPlayerScore: Int
}

struct TennisGameHistory {
    let setNumber: String
    let gameNumber: Int
    let winner: Competitor?
    let pointsTimeline: [String]
}
