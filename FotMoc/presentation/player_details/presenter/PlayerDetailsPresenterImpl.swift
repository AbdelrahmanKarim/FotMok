import Foundation
import Network
import Factory

class PlayerProfilePresenterImpl: PlayerProfilePresenter {
    
    private weak var view: PlayerProfileView?
    
    @Injected(\.getPlayerDetailsUseCase) private var playerDetailsUseCase
    @Injected(\.getPlayerProfileStatsUseCase) private var playerStatsUseCase
    
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = true
    private var pendingPlayerId: String?
    
    func attachView(_ view: PlayerProfileView) {
        self.view = view
        startMonitoring()
    }
    
    func detachView() {
        self.view = nil
        monitor?.cancel()
        monitor = nil
    }
    
    func retryLoading() {
        guard let id = pendingPlayerId else { return }
        loadPlayerData(playerId: id)
    }
    
    private func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let wasConnected = self.isConnected
            self.isConnected = path.status == .satisfied

            DispatchQueue.main.async {
                if self.isConnected && !wasConnected {
                    if let id = self.pendingPlayerId {
                        self.view?.hideNoInternet()
                        self.loadPlayerData(playerId: id)
                    }
                } else if !self.isConnected {
                    self.view?.showNoInternet()
                }
            }
        }
        monitor?.start(queue: DispatchQueue(label: "PlayerNetworkMonitor"))
    }

    private func guardConnectivity(playerId: String) -> Bool {
        pendingPlayerId = playerId
        if !isConnected {
            view?.showNoInternet()
            return false
        }
        return true
    }
    
    func loadPlayerData(playerId: String) {
        guard guardConnectivity(playerId: playerId) else { return }
        
        view?.showLoading()
        Task { @MainActor in
            do {
                async let fetchPlayer = playerDetailsUseCase.execute(playerId: playerId)
                async let fetchStats = try? playerStatsUseCase.execute(playerId: playerId)
                
                let (player, stats) = try await (fetchPlayer, fetchStats)
                
                view?.hideLoading()
                view?.displayPlayerProfile(player: player, stats: stats)
                
            } catch {
                view?.hideLoading()
                view?.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func didTapBack() {
        view?.navigateBack()
    }
}
