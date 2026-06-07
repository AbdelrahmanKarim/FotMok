//
//  TeamSeasonStats.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

import Foundation

struct TeamSeasonStats {
    let matchesPlayed: Int

    let points: Int
    let wins: Int
    let draws: Int
    let losses: Int
    let goalsFor: Int
    let goalsAgainst: Int
    let goalDifference: Int
    let cleanSheets: Int

    let fieldGoalsMade: Int
    let fieldGoalsAttempted: Int
    let threePointersMade: Int
    let avgPointsPerGame: Double
    let avgReboundsPerGame: Double
    let avgAssistsPerGame: Double

    let runsScored: Int
    let wicketsTaken: Int
    let highestScore: Int
    let nrr: Double
    let centuries: Int
    let halfCenturies: Int
}
