//
//  PlayerProfileStats.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

struct PlayerProfileStats {
    let season: PlayerSeasonStats
    let disciplinary: PlayerDisciplinaryStats
    let metrics: PlayerPerformanceMetrics
}

struct PlayerDisciplinaryStats {
    let yellowCards: Int
    let redCards: Int
}
struct PlayerPerformanceMetrics {
    let goalsPerMatch: Double
    let assistsPerMatch: Double
    let goalContributions: Int
}
struct PlayerSeasonStats {
    let goals: Int
    let assists: Int
    let matchesPlayed: Int
    let totalCards: Int
}
