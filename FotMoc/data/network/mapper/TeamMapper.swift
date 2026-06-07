import Foundation

extension TeamDTO {
    func toEntity(sport: SportType = .football) -> Team {
        return Team(
            id: String(teamKey ?? 0),
            name: teamName ?? "Unknown",
            logoUrl: teamLogo != nil ? URL(string: teamLogo!) : nil,
            sport: sport,
            countryName: nil,
            foundedYear: nil,
            description: nil
        )
    }

    func toSeasonStats(sport: SportType = .football) -> TeamSeasonStats {
        let played = players?.count ?? 0

        switch sport {

        case .football:
            let goalsFor = players?.compactMap { Int($0.playerGoals ?? "") }.reduce(0, +) ?? 0
            let goalsAgainst = players?.compactMap { Int($0.playerGoalsConceded ?? "") }.reduce(0, +) ?? 0
            let wins = players?.filter { ($0.playerMatchPlayed ?? "") > "0" }.count ?? 0
            let yellowCards = players?.compactMap { Int($0.playerYellowCards ?? "") }.reduce(0, +) ?? 0
            let redCards = players?.compactMap { Int($0.playerRedCards ?? "") }.reduce(0, +) ?? 0
            let saves = players?.compactMap { Int($0.playerSaves ?? "") }.reduce(0, +) ?? 0

            return TeamSeasonStats(
                matchesPlayed: played,
                points: wins * 3,
                wins: wins,
                draws: 0,
                losses: 0,
                goalsFor: goalsFor,
                goalsAgainst: goalsAgainst,
                goalDifference: goalsFor - goalsAgainst,
                cleanSheets: saves > 0 ? saves : 0,
                fieldGoalsMade: 0, fieldGoalsAttempted: 0,
                threePointersMade: 0, avgPointsPerGame: 0,
                avgReboundsPerGame: 0, avgAssistsPerGame: 0,
                runsScored: 0, wicketsTaken: 0,
                highestScore: 0, nrr: 0,
                centuries: 0, halfCenturies: 0
            )

        case .basketball:
            let totalPoints = players?.compactMap { Int($0.playerGoals ?? "") }.reduce(0, +) ?? 0
            let totalAssists = players?.compactMap { Int($0.playerAssists ?? "") }.reduce(0, +) ?? 0
            let totalBlocks = players?.compactMap { Int($0.playerBlocks ?? "") }.reduce(0, +) ?? 0
            let totalShots = players?.compactMap { Int($0.playerShotsTotal ?? "") }.reduce(0, +) ?? 0
            let validPlayed = played > 0 ? played : 1

            return TeamSeasonStats(
                matchesPlayed: played,
                points: totalPoints,
                wins: 0, draws: 0, losses: 0,
                goalsFor: 0, goalsAgainst: 0, goalDifference: 0, cleanSheets: 0,
                fieldGoalsMade: totalShots,
                fieldGoalsAttempted: totalShots,
                threePointersMade: 0,
                avgPointsPerGame: Double(totalPoints) / Double(validPlayed),
                avgReboundsPerGame: Double(totalBlocks) / Double(validPlayed),
                avgAssistsPerGame: Double(totalAssists) / Double(validPlayed),
                runsScored: 0, wicketsTaken: 0,
                highestScore: 0, nrr: 0,
                centuries: 0, halfCenturies: 0
            )

        case .cricket:
            let totalRuns = players?.compactMap { Int($0.playerGoals ?? "") }.reduce(0, +) ?? 0
            let totalWickets = players?.compactMap { Int($0.playerBlocks ?? "") }.reduce(0, +) ?? 0
            let highScore = players?.compactMap { Int($0.playerShotsTotal ?? "") }.max() ?? 0

            return TeamSeasonStats(
                matchesPlayed: played,
                points: 0, wins: 0, draws: 0, losses: 0,
                goalsFor: 0, goalsAgainst: 0, goalDifference: 0, cleanSheets: 0,
                fieldGoalsMade: 0, fieldGoalsAttempted: 0,
                threePointersMade: 0, avgPointsPerGame: 0,
                avgReboundsPerGame: 0, avgAssistsPerGame: 0,
                runsScored: totalRuns,
                wicketsTaken: totalWickets,
                highestScore: highScore,
                nrr: 0,
                centuries: 0,
                halfCenturies: 0
            )

        default:
            return TeamSeasonStats(
                matchesPlayed: played,
                points: 0, wins: 0, draws: 0, losses: 0,
                goalsFor: 0, goalsAgainst: 0, goalDifference: 0, cleanSheets: 0,
                fieldGoalsMade: 0, fieldGoalsAttempted: 0,
                threePointersMade: 0, avgPointsPerGame: 0,
                avgReboundsPerGame: 0, avgAssistsPerGame: 0,
                runsScored: 0, wicketsTaken: 0,
                highestScore: 0, nrr: 0,
                centuries: 0, halfCenturies: 0
            )
        }
    }
}

extension Players {
    func toEntity(teamId: String, sport: SportType = .football) -> Player {
        var validUrl: URL? = nil
        if let img = playerImage, !img.isEmpty {
            validUrl = URL(string: img)
        }

        let sportContext: PlayerSportContext
        switch sport {
        case .basketball:
            sportContext = .basketball(teamId: teamId, position: playerType ?? "Unknown")
        case .cricket:
            sportContext = .cricket(teamId: teamId, role: playerType ?? "Unknown")
        default:
            sportContext = .football(teamId: teamId, position: playerType ?? "Unknown")
        }

        return Player(
            id: String(playerKey ?? 0),
            name: playerName ?? "Unknown",
            imageUrl: validUrl,
            nationality: playerCountry,
            age: Int(playerAge ?? "0"),
            sportDetails: sportContext
        )
    }
}
