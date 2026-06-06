//
//  LatestPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation
import Factory
import Network

class LatestPresenterImpl: LatestPresenter {
    private weak var view: LatestView?
    private let sportProvider: CurrentSportProvider
    
    @Injected(\.getLeagueLatestMatchesUseCase) private var latestUseCase
    
    // Core connectivity flags
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = true
    private var isMonitoringStarted = false
    
    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
    }
    
    func attachView(_ view: LatestView) {
        self.view = view
        startMonitoring()
    }
    
    func detachView() {
        self.view = nil
        monitor?.cancel()
        monitor = nil
        isMonitoringStarted = false
    }
    
    func retryLoading() {
        loadLatestMatches()
    }
    
    private func startMonitoring() {
        guard !isMonitoringStarted else { return }
        isMonitoringStarted = true
        
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let wasConnected = self.isConnected
            self.isConnected = path.status == .satisfied
            
            DispatchQueue.main.async {
                if self.isConnected && !wasConnected {
                    self.view?.hideNoInternet()
                    self.loadLatestMatches()
                } else if !self.isConnected {
                    self.view?.hideLoading(then: nil)
                    self.view?.showNoInternet()
                }
            }
        }
        monitor?.start(queue: DispatchQueue(label: "LatestNetworkMonitor"))
    }
    
    private func guardConnectivity() -> Bool {
        if !isConnected {
            view?.hideLoading(then: nil)
            view?.showNoInternet()
            return false
        }
        return true
    }
    
    func loadLatestMatches() {
        guard guardConnectivity() else { return }
        
        view?.hideNoInternet()
        view?.showLoading()
        let leagueId = sportProvider.selectedLeague
        
        Task { @MainActor in
            do {
                let matches = try await latestUseCase.execute(leagueId: leagueId)
                if matches.isEmpty {
                    view?.hideLoading(then: { self.view?.displayEmptyState() })
                } else {
                    view?.hideLoading(then: { self.view?.displayMatches(matches) })
                }
            } catch {
                view?.hideLoading(then: { self.view?.displayError(message: error.localizedDescription) })
            }
        }
    }
    
    func didTapBack() {
        view?.navigateBack()
    }
}
