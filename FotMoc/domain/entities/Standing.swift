//
//  Standing.swift
//  FotMoc
//
//  Created by Alaa Ayman on 01/06/2026.
//


struct StandingRow {
    let rank: Int
    let competitor: Competitor
    let matchesPlayed: Int
    let wins: Int
    let losses: Int
    let points: Int?

    let sportMetrics: StandingMetrics
}

enum StandingMetrics {
    case football(draws: Int, goalDifference: Int)
    case basketball(winPercentage: Double)
    case cricket(noResults: Int, netRunRate: Double)
    case tennis(movement: String) 
}
