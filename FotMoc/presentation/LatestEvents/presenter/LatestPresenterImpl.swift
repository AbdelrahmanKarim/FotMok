//
//  LatestPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation
import Factory

class LatestPresenterImpl: LatestPresenter {
    private weak var view: LatestView?
    private let sportProvider: CurrentSportProvider
        
        @Injected(\.getLeagueLatestMatchesUseCase) private var latestUseCase
        
        init(sportProvider: CurrentSportProvider) {
            self.sportProvider = sportProvider
        }
        
        func attachView(_ view: LatestView) {
            self.view = view
        }
        
        func detachView() {
            self.view = nil
        }
        
  
    func loadLatestMatches() {
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
