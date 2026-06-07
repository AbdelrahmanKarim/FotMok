import Foundation
import Network
import Factory

class TeamDetailsPresenterImpl: TeamDetailsPresenter {
    
    private weak var view: TeamDetailsView?
    
    @Injected(\.getTeamDetailsUseCase) private var teamDetailsUseCase
    @Injected(\.getTeamSeasonStatsUseCase) private var teamStatsUseCase
    @Injected(\.getTeamPlayersUseCase) private var teamPlayersUseCase
    
    private var players: [Player] = []
    
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = true
    private var pendingTeamId: String?
    private var pendingLeagueId: String?
    
    func attachView(_ view: TeamDetailsView) {
        self.view = view
        startMonitoring()
    }
    
    func detachView() {
        self.view = nil
        monitor?.cancel()
        monitor = nil
    }
    
    func retryLoading() {
        guard let tId = pendingTeamId, let lId = pendingLeagueId else { return }
        loadTeamData(teamId: tId, leagueId: lId)
    }
    
    private func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let wasConnected = self.isConnected
            self.isConnected = path.status == .satisfied

            DispatchQueue.main.async {
                if self.isConnected && !wasConnected {
                    if let tId = self.pendingTeamId, let lId = self.pendingLeagueId {
                        self.view?.hideNoInternet()
                        self.loadTeamData(teamId: tId, leagueId: lId)
                    }
                } else if !self.isConnected {
                    self.view?.showNoInternet()
                }
            }
        }
        monitor?.start(queue: DispatchQueue(label: "TeamNetworkMonitor"))
    }
    
    private func guardConnectivity(teamId: String, leagueId: String) -> Bool {
        pendingTeamId = teamId
        pendingLeagueId = leagueId
        if !isConnected {
            view?.showNoInternet()
            return false
        }
        return true
    }
    
    func loadTeamData(teamId: String, leagueId: String) {
        guard guardConnectivity(teamId: teamId, leagueId: leagueId) else { return }
        
        view?.showLoading()
        
        Task { @MainActor in
            do {
                async let fetchTeam = teamDetailsUseCase.execute(teamId: teamId)
                async let fetchStats = try? teamStatsUseCase.execute(teamId: teamId, leagueId: leagueId)
                async let fetchPlayers = teamPlayersUseCase.execute(teamId: teamId)
                
                let (team, stats, fetchedPlayers) = try await (fetchTeam, fetchStats, fetchPlayers)
                
                self.players = fetchedPlayers
                
                view?.hideLoading()
                view?.displayTeamDetails(team: team, stats: stats, players: fetchedPlayers)
                
            } catch {
                view?.hideLoading()
                view?.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func didSelectPlayer(at index: Int) {
        guard index >= 0 && index < players.count else { return }
        let selectedPlayer = players[index]
        view?.navigateToPlayerProfile(playerId: selectedPlayer.id)
    }
    
    func didTapBack() {
        view?.navigateBack()
    }
}
