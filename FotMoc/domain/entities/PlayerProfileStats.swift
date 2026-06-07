import Foundation

struct PlayerProfileStats {
    let season: PlayerSeasonStats
    let disciplinary: PlayerDisciplinaryStats
    let metrics: PlayerPerformanceMetrics

    let blocks: Int?
    let tackles: Int?
    let saves: Int?
    let passes: Int?
    let shots: Int?
    let dribbles: Int?
    let interceptions: Int?
    let clearances: Int?
    let keyPasses: Int?
    let passAccuracy: String?
    let duelsWon: Int?
    let duelsTotal: Int?

    let penScored: Int?
    let penMissed: Int?
    let crossesTotal: Int?
    let insideBoxSaves: Int?
    let goalsConceded: Int?
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
    let minutesPlayed: Int
    let rating: String?
}
