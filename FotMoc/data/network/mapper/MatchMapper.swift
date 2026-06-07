//
//  MatchMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

extension MatchDTO {
    func toEntity(sport: SportType = .football) -> Match {
        // 1. Cross-resolve sport keys dynamically
        let homeName = (sport == .tennis) ? (eventFirstPlayer ?? "Unknown Player") : (eventHomeTeam ?? "Unknown Team")
        let awayName = (sport == .tennis) ? (eventSecondPlayer ?? "Unknown Player") : (eventAwayTeam ?? "Unknown Team")
        
        let homeKey = (sport == .tennis) ? (firstPlayerKey ?? 0) : (homeTeamKey ?? 0)
        let awayKey = (sport == .tennis) ? (secondPlayerKey ?? 0) : (awayTeamKey ?? 0)
        
        let homeLogoString = (sport == .tennis) ? eventFirstPlayerLogo : homeTeamLogo
        let awayLogoString = (sport == .tennis) ? eventSecondPlayerLogo : awayTeamLogo
        
        // 2. Format Dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = "\(eventDate ?? "") \(eventTime ?? "")"
        let matchDate = dateFormatter.date(from: dateString) ?? Date()
        
        // 3. Resolve Match Status
        let status: MatchStatus
        if eventStatus == "Finished" { status = .finished }
        else if eventStatus == "Postponed" { status = .postponed }
        else if eventStatus == "Cancelled" { status = .cancelled }
        else if eventLive == "1" { status = .live }
        else { status = .notStarted }
        
        // 4. Competitor Domain & Sport Details Resolution
        let homeCompetitor: Competitor
        let awayCompetitor: Competitor
        let sportDetails: SportMatchDetails
        
        if sport == .tennis {
            let homePlayer = Player(
                id: String(homeKey),
                name: homeName,
                imageUrl: homeLogoString.flatMap { URL(string: $0) },
                nationality: nil,
                age: nil,
                sportDetails: .tennis(rank: nil, plays: nil)
            )
            let awayPlayer = Player(
                id: String(awayKey),
                name: awayName,
                imageUrl: awayLogoString.flatMap { URL(string: $0) },
                nationality: nil,
                age: nil,
                sportDetails: .tennis(rank: nil, plays: nil)
            )
            homeCompetitor = .player(homePlayer)
            awayCompetitor = .player(awayPlayer)
            
            // Map set scores array safely from the updated DTO structures
            var tennisSets: [TennisSetScore] = []
            if let apiScores = self.scores {
                for scoreItem in apiScores {
                    if let setNumStr = scoreItem.scoreSet, let setNum = Int(setNumStr) {
                        // Safely handle optional tiebreaker scores (like "7.7") via Double casting
                        let p1Score = Int(Double(scoreItem.scoreFirst ?? "0") ?? 0)
                        let p2Score = Int(Double(scoreItem.scoreSecond ?? "0") ?? 0)
                        
                        tennisSets.append(TennisSetScore(
                            setNumber: setNum,
                            firstPlayerScore: p1Score,
                            secondPlayerScore: p2Score
                        ))
                    }
                }
            }
            
            let tennisDetails = TennisDetails(
                sets: tennisSets,
                currentServer: nil,
                currentPointScore: self.eventGameResult,
                pointByPointHistory: []
            )
            
            sportDetails = .tennis(liveSetStatus: eventStatus, details: tennisDetails)
        } else if sport == .cricket {
            let homeTeam = Team(id: String(homeKey), name: homeName,
                                logoUrl: homeLogoString.flatMap { URL(string: $0) },
                                sport: sport, countryName: nil, foundedYear: nil, description: nil)
            let awayTeam = Team(id: String(awayKey), name: awayName,
                                logoUrl: awayLogoString.flatMap { URL(string: $0) },
                                sport: sport, countryName: nil, foundedYear: nil, description: nil)
            homeCompetitor = .team(homeTeam)
            awayCompetitor = .team(awayTeam)

            // Map innings from scorecard if available (scorecard comes via MatchDTO extension or raw decode)
            // For now build a minimal CricketDetails from the top-level event fields
            let cricketDetails = CricketDetails(
                tossResult: nil,       // populate from eventToss if you add that field to MatchDTO
                matchStatusInfo: eventStatus,
                innings: []            // populate once you add scorecard to MatchDTO
            )
            sportDetails = .cricket(liveStatusInfo: eventStatus, details: cricketDetails)
        } else {
            // Default to Football Configuration Setup
            let homeTeam = Team(
                id: String(homeKey),
                name: homeName,
                logoUrl: homeLogoString.flatMap { URL(string: $0) },
                sport: sport,
                countryName: nil, foundedYear: nil, description: nil
            )
            let awayTeam = Team(
                id: String(awayKey),
                name: awayName,
                logoUrl: awayLogoString.flatMap { URL(string: $0) },
                sport: sport,
                countryName: nil, foundedYear: nil, description: nil
            )
            homeCompetitor = .team(homeTeam)
            awayCompetitor = .team(awayTeam)
            
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
            
            let footballDetails = FootballDetails(
                homeScore: homeScore,
                awayScore: awayScore,
                halftimeScore: eventHalftimeResult,
                events: matchEvents,
                lineups: nil,
                statistics: statistics?.map { MatchStatistic(type: $0.type ?? "", homeValue: $0.home ?? "0", awayValue: $0.away ?? "0") } ?? []
            )
            
            sportDetails = .football(liveMinute: eventStatus, details: footballDetails)
        }
        
        return Match(
            id: String(eventKey ?? 0),
            date: matchDate,
            status: status,
            leagueId: String(leagueKey ?? 0),
            sport: sport,
            homeCompetitor: homeCompetitor,
            awayCompetitor: awayCompetitor,
            score: eventFinalResult,
            sportDetails: sportDetails
        )
    }
}
