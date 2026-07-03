import Foundation

extension PlayerDTO {

    private var latestSinglesSeason: TennisSeasonStatsDTO? {
        return stats?
            .filter { $0.type == "singles" }
            .sorted { ($0.season ?? "") > ($1.season ?? "") }
            .first
    }

    private var isTennisPlayer: Bool {
        return stats != nil && !stats!.isEmpty
    }

    private var detectedSport: String {
        if isTennisPlayer { return "tennis" }

        let type = (playerType ?? "").lowercased()
        if type.contains("goalkeeper") || type.contains("defender") ||
           type.contains("midfielder") || type.contains("forward") ||
           type.contains("attacker") || type.contains("winger") {
            return "football"
        }
        if type.contains("guard") || type.contains("center") ||
           type.contains("small forward") || type.contains("power forward") ||
           type.contains("shooting guard") || type.contains("point guard") {
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
        // prefer player_logo over player_image (tennis uses player_logo)
        let imageUrl = [playerImage, playerLogo]
            .compactMap { $0 }
            .first { !$0.isEmpty }
            .flatMap { URL(string: $0) }

        let sport  = detectedSport
        let teamId = String(teamKey ?? 0)
        let position = playerType ?? "Unknown"

        let sportContext: PlayerSportContext
        switch sport {
        case "tennis":
            let rank = latestSinglesSeason?.rank.flatMap { Int($0) }
            sportContext = .tennis(rank: rank, plays: nil)
        case "basketball":
            sportContext = .basketball(teamId: teamId, position: position)
        case "cricket":
            sportContext = .cricket(teamId: teamId, role: position)
        default:
            sportContext = .football(teamId: teamId, position: position)
        }

        return Player(
            id: String(playerKey ?? 0),
            name: playerName ?? "Unknown",
            imageUrl: imageUrl,
            nationality: playerCountry,
            age: Int(playerAge ?? "0"),
            sportDetails: sportContext
        )
    }

    func toProfileStats() -> PlayerProfileStats {
        return isTennisPlayer ? tennisProfileStats() : regularProfileStats()
    }

    // MARK: - Tennis

    private func tennisProfileStats() -> PlayerProfileStats {
        let latest  = latestSinglesSeason
        let won     = Int(latest?.matchesWon  ?? "0") ?? 0
        let lost    = Int(latest?.matchesLost ?? "0") ?? 0
        let titles  = Int(latest?.titles      ?? "0") ?? 0
        let total   = won + lost
        let hardWon = Int(latest?.hardWon  ?? "0") ?? 0
        let clayWon = Int(latest?.clayWon  ?? "0") ?? 0
        let grassWon = Int(latest?.grassWon ?? "0") ?? 0
        let winRate = total > 0 ? String(format: "%.0f%%", Double(won) / Double(total) * 100) : "N/A"
        let rank    = latest?.rank ?? "N/A"

        return PlayerProfileStats(
            season: PlayerSeasonStats(
                goals: won,
                assists: titles,
                matchesPlayed: total,
                totalCards: 0,
                minutesPlayed: 0,
                rating: rank
            ),
            disciplinary: PlayerDisciplinaryStats(yellowCards: 0, redCards: 0),
            metrics: PlayerPerformanceMetrics(
                goalsPerMatch: total > 0 ? Double(won) / Double(total) : 0,
                assistsPerMatch: 0,
                goalContributions: titles
            ),
            blocks: hardWon,
            tackles: clayWon,
            saves: grassWon,
            passes: lost,
            shots: nil, dribbles: nil, interceptions: nil, clearances: nil,
            keyPasses: nil,
            passAccuracy: winRate,
            duelsWon: won,
            duelsTotal: total,
            penScored: nil, penMissed: nil, crossesTotal: nil,
            insideBoxSaves: nil, goalsConceded: nil
        )
    }

    // MARK: - Football / Basketball / Cricket

    private func regularProfileStats() -> PlayerProfileStats {
        let matches = Double(playerMatchPlayed ?? "1.0") ?? 1.0
        let valid   = matches > 0 ? matches : 1.0
        let goals   = Double(playerGoals   ?? "0.0") ?? 0.0
        let assists = Double(playerAssists ?? "0.0") ?? 0.0

        return PlayerProfileStats(
            season: PlayerSeasonStats(
                goals: Int(playerGoals   ?? "0") ?? 0,
                assists: Int(playerAssists ?? "0") ?? 0,
                matchesPlayed: Int(playerMatchPlayed ?? "0") ?? 0,
                totalCards: (Int(playerYellowCards ?? "0") ?? 0) + (Int(playerRedCards ?? "0") ?? 0),
                minutesPlayed: Int(playerMinutes ?? "0") ?? 0,
                rating: playerRating
            ),
            disciplinary: PlayerDisciplinaryStats(
                yellowCards: Int(playerYellowCards ?? "0") ?? 0,
                redCards: Int(playerRedCards    ?? "0") ?? 0
            ),
            metrics: PlayerPerformanceMetrics(
                goalsPerMatch: goals / valid,
                assistsPerMatch: assists / valid,
                goalContributions: Int(goals + assists)
            ),
            blocks: Int(playerBlocks       ?? ""),
            tackles: Int(playerTackles     ?? ""),
            saves: Int(playerSaves         ?? ""),
            passes: Int(playerPasses       ?? ""),
            shots: Int(playerShotsTotal    ?? ""),
            dribbles: Int(playerDribbleSucc ?? ""),
            interceptions: Int(playerInterceptions ?? ""),
            clearances: Int(playerClearances       ?? ""),
            keyPasses: Int(playerKeyPasses         ?? ""),
            passAccuracy: playerPassesAccuracy,
            duelsWon: Int(playerDuelsWon   ?? ""),
            duelsTotal: Int(playerDuelsTotal ?? ""),
            penScored: Int(playerPenScored  ?? ""),
            penMissed: Int(playerPenMissed  ?? ""),
            crossesTotal: Int(playerCrossesTotal   ?? ""),
            insideBoxSaves: Int(playerInsideBoxSaves ?? ""),
            goalsConceded: Int(playerGoalsConceded   ?? "")
        )
    }
}
