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
            points: standingPTS ?? 0,
            matchesPlayed: standingP ?? 0,
            goalDifference: standingGD ?? 0,
            wins: standingW ?? 0
        )
    }
}
