//
//  LiveMatchesPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import Factory

class LiveMatchesPresenterImpl: LiveMatchesPresenter {

    private weak var view: LiveMatchesView?
    private let sportProvider: CurrentSportProvider

    @Injected(\.getLiveMatchesUseCase) private var liveUseCase

    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
    }

    func attachView(_ view: LiveMatchesView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func loadLiveMatches() {
        view?.showLoading()
        let sport = sportProvider.selectedSport

        Task { @MainActor in
            do {
                let matches = try await liveUseCase.execute(sport: sport)
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
}
