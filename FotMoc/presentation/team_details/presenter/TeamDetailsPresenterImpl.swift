import Foundation
import Network
import Factory

class TeamDetailsPresenterImpl: TeamDetailsPresenter {
    
    private weak var view: TeamDetailsView?
    
    @Injected(\.getTeamDetailsUseCase) private var teamDetailsUseCase
    @Injected(\.getTeamSeasonStatsUseCase) private var teamStatsUseCase
    @Injected(\.getTeamPlayersUseCase) private var teamPlayersUseCase
    
    private var players: [Player] = []
    private let monitor = NWPathMonitor()
    private var isOnline = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = (path.status == .satisfied)
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func attachView(_ view: TeamDetailsView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func loadTeamData(teamId: String, leagueId: String) {
        guard isOnline else {
            DispatchQueue.main.async { [weak self] in
                self?.view?.displayError(message: "No internet connection. Please check your settings.")
            }
            return
        }
        
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
                
            } catch let error as AppException {
                view?.hideLoading()
                view?.displayError(message: error.localizedDescription)
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
