//
//  MatchMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

extension MatchDTO {
    func toEntity(sport: SportType = .football) -> Match {
        let homeTeam = Team(
            id: String(homeTeamKey ?? 0),
            name: eventHomeTeam ?? "Unknown",
            logoUrl: eventHomeTeam.flatMap { URL(string: $0) },
            sport: sport,
            countryName: nil, foundedYear: nil, description: nil
        )
        
        let awayTeam = Team(
            id: String(awayTeamKey ?? 0),
            name: eventAwayTeam ?? "Unknown",
            logoUrl: eventAwayTeam.flatMap { URL(string: $0) },
            sport: sport,
            countryName: nil, foundedYear: nil, description: nil
        )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = "\(eventDate ?? "") \(eventTime ?? "")"
        let matchDate = dateFormatter.date(from: dateString) ?? Date()
        
        let status: MatchStatus
        if eventStatus == "Finished" { status = .finished }
        else if eventStatus == "Postponed" { status = .postponed }
        else if eventStatus == "Cancelled" { status = .cancelled }
        else if eventLive == "1" { status = .live }
        else { status = .notStarted }
        
        let scoreParts = eventFinalResult?.split(separator: "-").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
        let homeScore = scoreParts.count == 2 ? (Int(scoreParts[0]) ?? 0) : 0
        let awayScore = scoreParts.count == 2 ? (Int(scoreParts[1]) ?? 0) : 0
        
        var matchEvents: [MatchEvent] = []
        
        if let goalscorers = self.goalscorers {
            for goal in goalscorers {
                let time = goal.time ?? ""
                if let homeScorer = goal.homeScorer, !homeScorer.isEmpty {
                    let assist = goal.homeAssist?.isEmpty == false ? goal.homeAssist : nil
                    matchEvents.append(MatchEvent(minute: time, type: .goal, primaryPlayerName: homeScorer, secondaryPlayerName: assist, isHomeTeam: true))
                } else if let awayScorer = goal.awayScorer, !awayScorer.isEmpty {
                    let assist = goal.awayAssist?.isEmpty == false ? goal.awayAssist : nil
                    matchEvents.append(MatchEvent(minute: time, type: .goal, primaryPlayerName: awayScorer, secondaryPlayerName: assist, isHomeTeam: false))
                }
            }
        }
        
        if let cards = self.cards {
            for card in cards {
                let time = card.time ?? ""
                let type: EventType = (card.card?.lowercased().contains("red") == true) ? .redCard : .yellowCard
                
                if let homeFault = card.homeFault, !homeFault.isEmpty {
                    matchEvents.append(MatchEvent(minute: time, type: type, primaryPlayerName: homeFault, secondaryPlayerName: nil, isHomeTeam: true))
                } else if let awayFault = card.awayFault, !awayFault.isEmpty {
                    matchEvents.append(MatchEvent(minute: time, type: type, primaryPlayerName: awayFault, secondaryPlayerName: nil, isHomeTeam: false))
                }
            }
        }
        
        if let substitutes = self.substitutes {
            for sub in substitutes {
                let time = sub.time ?? ""
                
                if case .detail(let detail) = sub.homeScorer, let pIn = detail.playerIn, let pOut = detail.playerOut {
                    matchEvents.append(MatchEvent(minute: time, type: .substitution, primaryPlayerName: pIn, secondaryPlayerName: pOut, isHomeTeam: true))
                }
                
                if case .detail(let detail) = sub.awayScorer, let pIn = detail.playerIn, let pOut = detail.playerOut {
                    matchEvents.append(MatchEvent(minute: time, type: .substitution, primaryPlayerName: pIn, secondaryPlayerName: pOut, isHomeTeam: false))
                }
            }
        }
        
        
        matchEvents.sort { event1, event2 in
            let time1Str = event1.minute.split(separator: "+").first ?? "0"
            let time2Str = event2.minute.split(separator: "+").first ?? "0"
            
            let time1Int = Int(time1Str.trimmingCharacters(in: .letters.union(.punctuationCharacters))) ?? 0
            let time2Int = Int(time2Str.trimmingCharacters(in: .letters.union(.punctuationCharacters))) ?? 0
            
            return time1Int < time2Int
        }
        
        let footballDetails = FootballDetails(
            homeScore: homeScore,
            awayScore: awayScore,
            halftimeScore: eventHalftimeResult,
            events: matchEvents,
            lineups: nil,
            statistics: statistics?.map { MatchStatistic(type: $0.type ?? "", homeValue: $0.home ?? "0", awayValue: $0.away ?? "0") } ?? []
        )
        
        return Match(
            id: String(eventKey ?? 0),
            date: matchDate,
            status: status,
            leagueId: String(leagueKey ?? 0),
            sport: sport,
            homeCompetitor: .team(homeTeam),
            awayCompetitor: .team(awayTeam),
            score: eventFinalResult,
            sportDetails: .football(liveMinute: eventStatus, details: footballDetails)
        )
    }
}
