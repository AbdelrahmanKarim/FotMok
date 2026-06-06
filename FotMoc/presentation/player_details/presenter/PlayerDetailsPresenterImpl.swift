import Foundation
import Network
import Factory

class PlayerProfilePresenterImpl: PlayerProfilePresenter {
    
    private weak var view: PlayerProfileView?
    
    @Injected(\.getPlayerDetailsUseCase) private var playerDetailsUseCase
    @Injected(\.getPlayerProfileStatsUseCase) private var playerStatsUseCase
    
    private let monitor = NWPathMonitor()
    private var isOnline = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = (path.status == .satisfied)
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func attachView(_ view: PlayerProfileView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func loadPlayerData(playerId: String) {
        guard isOnline else {
            DispatchQueue.main.async { [weak self] in
                self?.view?.displayError(message: "No internet connection. Please check your settings.")
            }
            return
        }
        
        view?.showLoading()
        
        Task { @MainActor in
            do {
                async let fetchPlayer = playerDetailsUseCase.execute(playerId: playerId)
                async let fetchStats = try? playerStatsUseCase.execute(playerId: playerId)
                
                let (player, stats) = try await (fetchPlayer, fetchStats)
                
                view?.hideLoading()
                view?.displayPlayerProfile(player: player, stats: stats)
                
            } catch let error as AppException {
                view?.hideLoading()
                view?.displayError(message: error.localizedDescription)
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
