//
//  MatchRepositoryImpl.swift
//  FotMoc
//


import Foundation
import Factory

class MatchRepositoryImpl: MatchRepository {
    private let remoteDataSource: MatchRemoteDataSource
    private let sportProvider: CurrentSportProvider
        
    init(remoteDataSource: MatchRemoteDataSource, sportProvider: CurrentSportProvider) {
        self.remoteDataSource = remoteDataSource
        self.sportProvider = sportProvider
    }
    
    func getHeadToHeadUpcomingMatch(teamId1: String, teamId2: String) async throws -> Match {
        let sport = sportProvider.selectedSport
        let response = try await remoteDataSource.getH2H(sport: sport.rawValue, firstTeamId: teamId1, secondTeamId: teamId2)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let today = Calendar.current.startOfDay(for: Date())
        
        let upcomingH2H = response.h2H?.first { h2h in
            if h2h.eventStatus != "Finished" && h2h.eventStatus != "Cancelled" {
                if let dateStr = h2h.eventDate, let matchDate = dateFormatter.date(from: dateStr) {
                    return matchDate >= today
                }
            }
            return false
        }
        
        guard let upcomingMatch = upcomingH2H else {
            throw AppException.custom(message: "There are no upcoming matches scheduled between these two teams.")
        }
        
 
        let matchDTO = MatchDTO(
            eventKey: upcomingMatch.eventKey, eventDate: upcomingMatch.eventDate, eventTime: upcomingMatch.eventTime,
            eventHalftimeResult: upcomingMatch.eventHalftimeResult, eventFinalResult: upcomingMatch.eventFinalResult,
            eventFtResult: nil, eventPenaltyResult: nil, eventStatus: upcomingMatch.eventStatus,
            countryName: upcomingMatch.countryName, leagueName: upcomingMatch.leagueName, leagueKey: upcomingMatch.leagueKey,
            leagueRound: upcomingMatch.leagueRound, leagueSeason: upcomingMatch.leagueSeason, eventLive: upcomingMatch.eventLive,
            eventStadium: nil, eventReferee: nil, eventCountryKey: upcomingMatch.eventCountryKey,
            leagueLogo: nil, countryLogo: nil, eventHomeFormation: nil, eventAwayFormation: nil,
            fkStageKey: nil, stageName: nil, leagueGroup: nil,
            
       
            eventHomeTeam: upcomingMatch.eventHomeTeam, homeTeamKey: upcomingMatch.homeTeamKey,
            eventAwayTeam: upcomingMatch.eventAwayTeam, awayTeamKey: upcomingMatch.awayTeamKey,
            homeTeamLogo: upcomingMatch.homeTeamLogo, awayTeamLogo: upcomingMatch.awayTeamLogo,
            
          
            eventFirstPlayer: nil, firstPlayerKey: nil, eventSecondPlayer: nil, secondPlayerKey: nil,
            eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventGameResult: nil, scores: nil,
            
            goalscorers: nil, substitutes: nil, cards: nil, vars: nil, lineups: nil, statistics: nil
        )
        
        return matchDTO.toEntity(sport: sport)
    }

    func getHeadToHeadPreviousMatches(teamId1: String, teamId2: String) async throws -> [Match] {
        let sport = sportProvider.selectedSport
        let response = try await remoteDataSource.getH2H(sport: sport.rawValue, firstTeamId: teamId1, secondTeamId: teamId2)
        let matchDTOs = (response.h2H ?? []).map { h2h in
          
            MatchDTO(
                eventKey: h2h.eventKey, eventDate: h2h.eventDate, eventTime: h2h.eventTime,
                eventHalftimeResult: h2h.eventHalftimeResult, eventFinalResult: h2h.eventFinalResult,
                eventFtResult: nil, eventPenaltyResult: nil, eventStatus: h2h.eventStatus,
                countryName: h2h.countryName, leagueName: h2h.leagueName, leagueKey: h2h.leagueKey,
                leagueRound: h2h.leagueRound, leagueSeason: h2h.leagueSeason, eventLive: h2h.eventLive,
                eventStadium: nil, eventReferee: nil, eventCountryKey: h2h.eventCountryKey,
                leagueLogo: nil, countryLogo: nil, eventHomeFormation: nil, eventAwayFormation: nil,
                fkStageKey: nil, stageName: nil, leagueGroup: nil,
              
                eventHomeTeam: h2h.eventHomeTeam, homeTeamKey: h2h.homeTeamKey,
                eventAwayTeam: h2h.eventAwayTeam, awayTeamKey: h2h.awayTeamKey,
                homeTeamLogo: h2h.homeTeamLogo, awayTeamLogo: h2h.awayTeamLogo,
               
                eventFirstPlayer: nil, firstPlayerKey: nil, eventSecondPlayer: nil, secondPlayerKey: nil,
                eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil, eventGameResult: nil, scores: nil,
                
                goalscorers: nil, substitutes: nil, cards: nil, vars: nil, lineups: nil, statistics: nil
            )
        }
        return matchDTOs.map { $0.toEntity(sport: sport) }
    }
        
    func getLeagueLatestMatches(leagueId: String) async throws -> [Match] {
        let sport = sportProvider.selectedSport
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        let today = formatter.string(from: Date())

        let daysBack: Int = (sport == .tennis || sport == .cricket) ? -7 : -60
        let pastDate = formatter.string(from: Calendar.current.date(byAdding: .year, value: daysBack, to: Date())!)

        let dtos = try await remoteDataSource.getFixtures(
            sport: sport.rawValue, leagueId: leagueId, from: pastDate, to: today
        )
        return dtos.map { $0.toEntity(sport: sport) }
    }

    func getLeagueUpcomingMatches(leagueId: String) async throws -> [Match] {
        let sport = sportProvider.selectedSport
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        let tomorrow = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)

      
        let isTennisorCricket = sport == .tennis || sport == .cricket
        let futureDate = formatter.string(from: Calendar.current.date(
            byAdding: isTennisorCricket ? .year : .day,
            value: isTennisorCricket ? 1 : 14,
            to: Date()
        )!)

        let dtos = try await remoteDataSource.getFixtures(
            sport: sport.rawValue, leagueId: leagueId, from: tomorrow, to: futureDate
        )
        return dtos.map { $0.toEntity(sport: sport) }
    }
    func getLiveMatches(sport: SportType) async throws -> [Match] {
        let dtos = try await remoteDataSource.getLiveScores(sport: sport.rawValue)
        return dtos.map { $0.toEntity(sport: sport) }
    }
    
    func getMatchDetails(matchId: String) async throws -> Match {
        let currentSport = sportProvider.selectedSport
        let matchDTO = try await remoteDataSource.getMatchDetails(sport: currentSport, matchId: matchId)
        return matchDTO.toEntity(sport: currentSport)
    }
}
