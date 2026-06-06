//
//  HeadToHeadPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation
import Factory
import Network

class HeadToHeadPresenterImpl: HeadToHeadPresenter {

    private weak var view: HeadToHeadView?

    @Injected(\.getHeadToHeadUpcomingMatchUseCase)  private var upcomingUseCase
    @Injected(\.getHeadToHeadPreviousMatchesUseCase) private var previousUseCase
    @Injected(\.getOverallHeadToHeadRecordUseCase)   private var recordUseCase
    @Injected(\.getTeamRecentFormUseCase)            private var formUseCase

    // Core connectivity properties
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = true
    private var isMonitoringStarted = false
    
    // Caches the arguments needed to retry loading the data
    private var pendingRequestParams: (teamId1: String, teamId2: String, leagueId: String)?

    func attachView(_ view: HeadToHeadView) {
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
        retryAll()
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
                    self.retryAll()
                } else if !self.isConnected {
                    self.view?.hideLoading(then: nil)
                    self.view?.showNoInternet()
                }
            }
        }
        monitor?.start(queue: DispatchQueue(label: "H2HNetworkMonitor"))
    }

    private func retryAll() {
        guard let params = pendingRequestParams else { return }
        loadData(teamId1: params.teamId1, teamId2: params.teamId2, leagueId: params.leagueId)
    }

    private func guardConnectivity(teamId1: String, teamId2: String, leagueId: String) -> Bool {
        pendingRequestParams = (teamId1, teamId2, leagueId)
        if !isConnected {
            view?.hideLoading(then: nil)
            view?.showNoInternet()
            return false
        }
        return true
    }

    func didTapBack() {
        view?.navigateBack()
    }

    func loadData(teamId1: String, teamId2: String, leagueId: String) {
        guard guardConnectivity(teamId1: teamId1, teamId2: teamId2, leagueId: leagueId) else { return }
        
        view?.hideNoInternet()
        view?.showLoading()

        Task { @MainActor in
            async let upcomingResult   = upcomingUseCase.execute(teamId1: teamId1, teamId2: teamId2)
            async let previousResult   = previousUseCase.execute(teamId1: teamId1, teamId2: teamId2)
            async let recordResult     = recordUseCase.execute(teamId1: teamId1, teamId2: teamId2)
            async let form1Result      = formUseCase.execute(teamId: teamId1, leagueId: leagueId)
            async let form2Result      = formUseCase.execute(teamId: teamId2, leagueId: leagueId)

            let upcoming  = try? await upcomingResult
            let previous  = (try? await previousResult) ?? []
            let record    = try? await recordResult
            let form1     = try? await form1Result
            let form2     = try? await form2Result

            view?.hideLoading(then: {
                self.view?.displayUpcomingMatch(upcoming)
                self.view?.displayPreviousMatches(previous)
                if let r = record { self.view?.displayOverallRecord(r) }
                if let f1 = form1, let f2 = form2 {
                    self.view?.displayRecentForm(firstTeam: f1, secondTeam: f2)
                }
            })
        }
    }
}
