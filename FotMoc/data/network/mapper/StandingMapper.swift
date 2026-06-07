//
//  StandingMapper.swift
//  FotMoc
//

import Foundation

extension Total {
    func toEntity(sport: SportType = .football) -> StandingRow {
        let team = Team(
            id: String(teamKey ?? 0),
            name: standingTeam ?? "Unknown",
            logoUrl: teamLogo != nil ? URL(string: teamLogo!) : nil,
            sport: sport,
            countryName: nil, foundedYear: nil, description: nil
        )
        
        return StandingRow(
            rank: standingPlace ?? 0,
            competitor: .team(team),
            matchesPlayed: standingP ?? 0,	
            wins: standingW ?? 0,
            losses: standingL ?? 0,
            points: standingPTS ?? 0,
            sportMetrics: .football(
                draws: standingD ?? 0,
                goalDifference: standingGD ?? 0,
                goalsFor: standingF ?? 0,
                goalsAgainst: standingA ?? 0
            )
        )
    }
    
    func toSeasonStats() -> TeamSeasonStats {
        return TeamSeasonStats(
            matchesPlayed: standingP ?? 0,
            points: standingPTS ?? 0,
            wins: standingW ?? 0,
            draws: standingD ?? 0,
            losses: standingL ?? 0,
            goalsFor: standingF ?? 0,
            goalsAgainst: standingA ?? 0,
            goalDifference: standingGD ?? 0,
            cleanSheets: 0,
            fieldGoalsMade: 0,
            fieldGoalsAttempted: 0,
            threePointersMade: 0,
            avgPointsPerGame: 0,
            avgReboundsPerGame: 0,
            avgAssistsPerGame: 0,
            runsScored: 0,
            wicketsTaken: 0,
            highestScore: 0,
            nrr: 0,
            centuries: 0,
            halfCenturies: 0
        )
    }
}
