//
//  HeadToHeadPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

import Factory

class HeadToHeadPresenterImpl: HeadToHeadPresenter {

    private weak var view: HeadToHeadView?

    @Injected(\.getHeadToHeadUpcomingMatchUseCase)  private var upcomingUseCase
    @Injected(\.getHeadToHeadPreviousMatchesUseCase) private var previousUseCase
    @Injected(\.getOverallHeadToHeadRecordUseCase)  private var recordUseCase
    @Injected(\.getTeamRecentFormUseCase)            private var formUseCase

    func attachView(_ view: HeadToHeadView) {
        self.view = view
    }

    func detachView() {
        self.view = nil
    }

    func didTapBack() {
        view?.navigateBack()
    }

    func loadData(teamId1: String, teamId2: String, leagueId: String) {
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
