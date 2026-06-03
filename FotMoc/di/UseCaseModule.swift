//
//  UseCaseModule.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import Factory

extension Container {
    
    var getFavouriteLeaguesUseCase: Factory<GetFavouriteLeaguesUseCase> {
        self { GetFavouriteLeaguesUseCase(repository: self.leagueRepository()) }
    }
    var getLeagueDetailsUseCase: Factory<GetLeagueDetailsUseCase> {
        self { GetLeagueDetailsUseCase(repository: self.leagueRepository()) }
    }
    var getLeaguesUseCase: Factory<GetLeaguesUseCase> {
        self { GetLeaguesUseCase(repository: self.leagueRepository()) }
    }
    var getLeagueTableStandingsUseCase: Factory<GetLeagueTableStandingsUseCase> {
        self { GetLeagueTableStandingsUseCase(repository: self.leagueRepository()) }
    }
    var saveFavouriteLeagueUseCase: Factory<SaveFavouriteLeagueUseCase> {
        self { SaveFavouriteLeagueUseCase(repository: self.leagueRepository()) }
    }
    var searchLeaguesUseCase: Factory<SearchLeaguesUseCase> {
        self { SearchLeaguesUseCase(repository: self.leagueRepository()) }
    }
    
    var getHeadToHeadPreviousMatchesUseCase: Factory<GetHeadToHeadPreviousMatchesUseCase> {
        self { GetHeadToHeadPreviousMatchesUseCase(repository: self.matchRepository()) }
    }
    var getHeadToHeadUpcomingMatchUseCase: Factory<GetHeadToHeadUpcomingMatchUseCase> {
        self { GetHeadToHeadUpcomingMatchUseCase(repository: self.matchRepository()) }
    }
    var getLeagueLatestMatchesUseCase: Factory<GetLeagueLatestMatchesUseCase> {
        self { GetLeagueLatestMatchesUseCase(repository: self.matchRepository()) }
    }
    var getLeagueUpcomingMatchesUseCase: Factory<GetLeagueUpcomingMatchesUseCase> {
        self { GetLeagueUpcomingMatchesUseCase(repository: self.matchRepository()) }
    }
    var getLiveMatchesUseCase: Factory<GetLiveMatchesUseCase> {
        self { GetLiveMatchesUseCase(repository: self.matchRepository()) }
    }
    var getMatchDetailsUseCase: Factory<GetMatchDetailsUseCase> {
        self { GetMatchDetailsUseCase(repository: self.matchRepository()) }
    }
    
    var getLeaguePlayersUseCase: Factory<GetLeaguePlayersUseCase> {
        self { GetLeaguePlayersUseCase(repository: self.playerRepository()) }
    }
    var getLeagueTopScorersUseCase: Factory<GetLeagueTopScorersUseCase> {
        self { GetLeagueTopScorersUseCase(repository: self.playerRepository()) }
    }
    var getPlayerDetailsUseCase: Factory<GetPlayerDetailsUseCase> {
        self { GetPlayerDetailsUseCase(repository: self.playerRepository()) }
    }
    var getPlayerProfileStatsUseCase: Factory<GetPlayerProfileStatsUseCase> {
        self { GetPlayerProfileStatsUseCase(repository: self.playerRepository()) }
    }
    var getTeamPlayersUseCase: Factory<GetTeamPlayersUseCase> {
        self { GetTeamPlayersUseCase(repository: self.playerRepository()) }
    }
    
    var getLeagueTeamsUseCase: Factory<GetLeagueTeamsUseCase> {
        self { GetLeagueTeamsUseCase(repository: self.teamRepository()) }
    }
    var getOverallHeadToHeadRecordUseCase: Factory<GetOverallHeadToHeadRecordUseCase> {
        self { GetOverallHeadToHeadRecordUseCase(repository: self.teamRepository()) }
    }
    var getTeamDetailsUseCase: Factory<GetTeamDetailsUseCase> {
        self { GetTeamDetailsUseCase(repository: self.teamRepository()) }
    }
    var getTeamRecentFormUseCase: Factory<GetTeamRecentFormUseCase> {
        self { GetTeamRecentFormUseCase(repository: self.teamRepository()) }
    }
    var getTeamSeasonStatsUseCase: Factory<GetTeamSeasonStatsUseCase> {
        self { GetTeamSeasonStatsUseCase(repository: self.teamRepository()) }
    }
}
