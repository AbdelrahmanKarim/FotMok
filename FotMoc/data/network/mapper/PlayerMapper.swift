//
//  PlayerMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation


extension PlayerDTO {
    func toEntity() -> Player {
        var validImageUrl: URL? = nil
        if let imageString = playerImage, !imageString.isEmpty {
            validImageUrl = URL(string: imageString)
        }
        return Player(
            id: String(playerKey ?? 0),
            name: playerName ?? "Unknown",
            imageUrl: validImageUrl,
            nationality: playerCountry,
            age: Int(playerAge ?? "0"),
            sportDetails: .teamSport(teamId: String(teamKey ?? 0), position: playerType ?? "Unknown")
        )
    }
    
    func toProfileStats() -> PlayerProfileStats {
        let seasonStats = PlayerSeasonStats(
            goals: Int(playerGoals ?? "0") ?? 0,
            assists: Int(playerAssists ?? "0") ?? 0,
            matchesPlayed: Int(playerMatchPlayed ?? "0") ?? 0,
            totalCards: (Int(playerYellowCards ?? "0") ?? 0) + (Int(playerRedCards ?? "0") ?? 0)
        )
        
        let disciplinaryStats = PlayerDisciplinaryStats(
            yellowCards: Int(playerYellowCards ?? "0") ?? 0,
            redCards: Int(playerRedCards ?? "0") ?? 0
        )
        
        let matches = Double(playerMatchPlayed ?? "1.0") ?? 1.0
        let validMatches = matches > 0 ? matches : 1.0
        let goals = Double(playerGoals ?? "0.0") ?? 0.0
        let assists = Double(playerAssists ?? "0.0") ?? 0.0
        
        let metrics = PlayerPerformanceMetrics(
            goalsPerMatch: goals / validMatches,
            assistsPerMatch: assists / validMatches,
            goalContributions: Int(goals + assists)
        )
        
        return PlayerProfileStats(season: seasonStats, disciplinary: disciplinaryStats, metrics: metrics)
    }
}

