//
//  HeadToHeadMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//
//

import Foundation

extension H2HResponseDTO {
    func toEntity(targetTeamId: String, opponentTeamId: String) -> HeadToHeadRecord {
        var firstTeamWins = 0
        var secondTeamWins = 0
        var draws = 0
        
        for match in h2H ?? [] {
            let homeId = String(match.homeTeamKey ?? 0)
            let awayId = String(match.awayTeamKey ?? 0)
            
            let scoreParts = (match.eventFinalResult ?? "").split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) }
            if scoreParts.count == 2, let homeScore = Int(scoreParts[0]), let awayScore = Int(scoreParts[1]) {
                if homeScore > awayScore {
                    if homeId == targetTeamId { firstTeamWins += 1 } else { secondTeamWins += 1 }
                } else if awayScore > homeScore {
                    if awayId == targetTeamId { firstTeamWins += 1 } else { secondTeamWins += 1 }
                } else {
                    draws += 1
                }
            }
        }
        
        return HeadToHeadRecord(firstTeamWins: firstTeamWins, draws: draws, secondTeamWins: secondTeamWins)
    }
}
