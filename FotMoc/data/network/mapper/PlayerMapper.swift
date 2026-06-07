import Foundation

extension PlayerDTO {

    private var detectedSport: String {
        let type = (playerType ?? "").lowercased()
        let name = (playerName ?? "").lowercased()

        if type.contains("goalkeeper") || type.contains("defender") ||
           type.contains("midfielder") || type.contains("forward") ||
           type.contains("attacker") || type.contains("winger") {
            return "football"
        }
        if type.contains("guard") || type.contains("forward") && name.contains("nba") ||
           type.contains("center") || type.contains("small forward") ||
           type.contains("power forward") || type.contains("shooting guard") ||
           type.contains("point guard") {
            return "basketball"
        }
        if type.contains("batsman") || type.contains("bowler") ||
           type.contains("all-rounder") || type.contains("wicket") {
            return "cricket"
        }
        if teamKey == nil || teamKey == 0 {
            return "tennis"
        }
        return "football"
    }

    func toEntity() -> Player {
        var validImageUrl: URL? = nil
        if let imageString = playerImage, !imageString.isEmpty {
            validImageUrl = URL(string: imageString)
        }

        let sport = detectedSport
        let teamId = String(teamKey ?? 0)
        let position = playerType ?? "Unknown"

        let sportContext: PlayerSportContext
        switch sport {
        case "basketball":
            sportContext = .basketball(teamId: teamId, position: position)
        case "cricket":
            sportContext = .cricket(teamId: teamId, role: position)
        case "tennis":
            sportContext = .tennis(rank: Int(playerNumber ?? ""), plays: playerType)
        default:
            sportContext = .football(teamId: teamId, position: position)
        }

        return Player(
            id: String(playerKey ?? 0),
            name: playerName ?? "Unknown",
            imageUrl: validImageUrl,
            nationality: playerCountry,
            age: Int(playerAge ?? "0"),
            sportDetails: sportContext
        )
    }

    func toProfileStats() -> PlayerProfileStats {
        let matches = Double(playerMatchPlayed ?? "1.0") ?? 1.0
        let validMatches = matches > 0 ? matches : 1.0
        let goals = Double(playerGoals ?? "0.0") ?? 0.0
        let assists = Double(playerAssists ?? "0.0") ?? 0.0

        let seasonStats = PlayerSeasonStats(
            goals: Int(playerGoals ?? "0") ?? 0,
            assists: Int(playerAssists ?? "0") ?? 0,
            matchesPlayed: Int(playerMatchPlayed ?? "0") ?? 0,
            totalCards: (Int(playerYellowCards ?? "0") ?? 0) + (Int(playerRedCards ?? "0") ?? 0),
            minutesPlayed: Int(playerMinutes ?? "0") ?? 0,
            rating: playerRating
        )

        let disciplinaryStats = PlayerDisciplinaryStats(
            yellowCards: Int(playerYellowCards ?? "0") ?? 0,
            redCards: Int(playerRedCards ?? "0") ?? 0
        )

        let metrics = PlayerPerformanceMetrics(
            goalsPerMatch: goals / validMatches,
            assistsPerMatch: assists / validMatches,
            goalContributions: Int(goals + assists)
        )

        return PlayerProfileStats(
            season: seasonStats,
            disciplinary: disciplinaryStats,
            metrics: metrics,
            blocks: Int(playerBlocks ?? ""),
            tackles: Int(playerTackles ?? ""),
            saves: Int(playerSaves ?? ""),
            passes: Int(playerPasses ?? ""),
            shots: Int(playerShotsTotal ?? ""),
            dribbles: Int(playerDribbleSucc ?? ""),
            interceptions: Int(playerInterceptions ?? ""),
            clearances: Int(playerClearances ?? ""),
            keyPasses: Int(playerKeyPasses ?? ""),
            passAccuracy: playerPassesAccuracy,
            duelsWon: Int(playerDuelsWon ?? ""),
            duelsTotal: Int(playerDuelsTotal ?? ""),
            penScored: Int(playerPenScored ?? ""),
            penMissed: Int(playerPenMissed ?? ""),
            crossesTotal: Int(playerCrossesTotal ?? ""),
            insideBoxSaves: Int(playerInsideBoxSaves ?? ""),
            goalsConceded: Int(playerGoalsConceded ?? "")
        )
    }
}
