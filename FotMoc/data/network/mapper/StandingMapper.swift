//
//  Standings Mapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//
import Foundation

extension Total {
    func toEntity(sport: SportType = .football) -> StandingRow {
        let team = Team(
            id: String(teamKey),
            name: standingTeam,
            logoUrl: URL(string: teamLogo),
            sport: sport,
            countryName: nil, foundedYear: nil, description: nil
        )
        
        return StandingRow(
            rank: standingPlace,
            competitor: .team(team),
            matchesPlayed: standingP,
            wins: standingW,
            losses: standingL,
            points: standingPTS,
            sportMetrics: .football(
                draws: standingD,
                goalDifference: standingGD,
                goalsFor: standingF,
                goalsAgainst: standingA
            )
        )
    }
    
    func toSeasonStats() -> TeamSeasonStats {
        return TeamSeasonStats(
            points: standingPTS,
            matchesPlayed: standingP,
            goalDifference: standingGD,
            wins: standingW
        )
    }
}
