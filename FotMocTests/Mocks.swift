import Foundation
import RxSwift
@testable import FotMoc



class MockPlayerRepository: PlayerRepository {
    func getLeaguePlayers(leagueId: String) async throws -> [FotMoc.Player] { return [] }
    func getLeagueTopScorers(leagueId: String) async throws -> [FotMoc.TopScorer] { return [] }
    
    var playerToReturn: Player!
    var shouldThrow = false
    
    func getPlayerDetails(playerId: String) async throws -> Player {
        if shouldThrow { throw AppException.notFound }
        return playerToReturn
    }
    
    func getPlayerProfileStats(playerId: String) async throws -> PlayerProfileStats {
        throw AppException.notFound
    }
    
    func getTeamPlayers(teamId: String) async throws -> [Player] { return [] }
}

class MockTeamRepository: TeamRepository {
    func getLeagueTeams(leagueId: String) async throws -> [FotMoc.Team] { return [] }
    func getOverallHeadToHeadRecord(teamId1: String, teamId2: String) async throws -> FotMoc.HeadToHeadRecord { throw AppException.notFound }
    func getTeamRecentForm(teamId: String, leagueId: String) async throws -> FotMoc.TeamRecentForm { throw AppException.notFound }
    
    var teamToReturn: Team!
    func getTeamDetails(teamId: String) async throws -> Team { return teamToReturn }
    func getTeamSeasonStats(teamId: String, leagueId: String) async throws -> TeamSeasonStats { throw AppException.notFound }
}

class MockMatchRepository: MatchRepository {
    func getHeadToHeadPreviousMatches(teamId1: String, teamId2: String) async throws -> [FotMoc.Match] { return [] }
    func getHeadToHeadUpcomingMatch(teamId1: String, teamId2: String) async throws -> FotMoc.Match { throw AppException.notFound }
    func getLeagueLatestMatches(leagueId: String) async throws -> [FotMoc.Match] { return [] }
    func getLeagueUpcomingMatches(leagueId: String) async throws -> [FotMoc.Match] { return [] }
    func getMatchDetails(matchId: String) async throws -> FotMoc.Match { throw AppException.notFound }
    
    var matchesToReturn: [Match] = []
    func getLiveMatches(sport: SportType) async throws -> [Match] { return matchesToReturn }
}

class MockLeagueRepository: LeagueRepository {
    func getLeagues(sport: FotMoc.SportType) async throws -> [FotMoc.League] { return [] }
    func getLeagueTableStandings(leagueId: String) async throws -> [FotMoc.StandingRow] { return [] }
    func getLeagueDetails(leagueId: String) async throws -> FotMoc.League { throw AppException.notFound }
    func searchLeagues(query: String) -> RxSwift.Observable<[FotMoc.League]> { return .empty() }
    
    var savedLeague: League?
    func saveFavouriteLeague(league: League) async throws { savedLeague = league }
    func getFavouriteLeagues() async throws -> [League] { return [] }
    func removeFavouriteLeague(id: String) async throws { }
}



class MockLiveMatchesView: LiveMatchesView {
    var displayMatchesCalled = false
    var displayEmptyStateCalled = false
    var hideLoadingCalled = false
    
    func showLoading() {}
    func hideLoading(then completion: (() -> Void)?) {
        hideLoadingCalled = true
        completion?()
    }
    func displayMatches(_ matches: [Match]) { displayMatchesCalled = true }
    func displayEmptyState() { displayEmptyStateCalled = true }
    func displayError(message: String) {}
    func showNoInternet() {}
    func hideNoInternet() {}
    func navigateBack() {}
}

class MockPlayerProfileView: PlayerProfileView {
    var displayProfileCalled = false
    var displayedPlayer: Player?
    
    func showLoading() {}
    func hideLoading() {}
    func displayPlayerProfile(player: Player, stats: PlayerProfileStats?) {
        displayProfileCalled = true
        displayedPlayer = player
    }
    func displayError(message: String) {}
    func navigateBack() {}
}

class MockTeamDetailsView: TeamDetailsView {
    var displayTeamCalled = false
    func showLoading() {}
    func hideLoading() {}
    func displayTeamDetails(team: Team, stats: TeamSeasonStats?, players: [Player]) { displayTeamCalled = true }
    func displayError(message: String) {}
    func navigateBack() {}
    func navigateToPlayerProfile(playerId: String) {}
}




class MockGetLiveMatchesUseCase: GetLiveMatchesUseCase {
    var matchesToReturn: [Match] = []
    override func execute(sport: SportType) async throws -> [Match] { return matchesToReturn }
}

class MockGetPlayerDetailsUseCase: GetPlayerDetailsUseCase {
    var playerToReturn: Player!
    override func execute(playerId: String) async throws -> Player { return playerToReturn }
}

class MockGetPlayerProfileStatsUseCase: GetPlayerProfileStatsUseCase {
    override func execute(playerId: String) async throws -> PlayerProfileStats { throw AppException.notFound }
}

class MockGetTeamSeasonStatsUseCase: GetTeamSeasonStatsUseCase {
    override func execute(teamId: String, leagueId: String) async throws -> TeamSeasonStats { throw AppException.notFound }
}

class MockGetTeamPlayersUseCase: GetTeamPlayersUseCase {
    override func execute(teamId: String) async throws -> [Player] { return [] }
}
