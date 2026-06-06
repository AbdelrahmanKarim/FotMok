//
//  CoreModule.swift
//  FotMoc
//
//  Created by abdelrahman karim on 04/06/2026.
//

import Factory
import Foundation

class CurrentSportProvider {
    var selectedSport: SportType = .football
    var selectedLeague: String = "152"
}


extension Container {
    var currentSportProvider: Factory<CurrentSportProvider> {
        self { CurrentSportProvider() }.singleton
    }
    var homePresenter: Factory<HomePresenter> {
            self { HomePresenterImpl(sportProvider: self.currentSportProvider()) }
        }
    var leagueDetailsPresenter: Factory<LeagueDetailsPresenter> {
            self { LeagueDetailsPresenterImpl(sportProvider: self.currentSportProvider()) }
        }
    var latestEventsPresenter: Factory<LatestPresenter> {
        self { LatestPresenterImpl(sportProvider: self.currentSportProvider()) }
     }
    var liveMatchesPresenter: Factory<LiveMatchesPresenter> {
        self { LiveMatchesPresenterImpl(sportProvider: self.currentSportProvider()) }
     }
    var headToHeadPresenter: Factory<HeadToHeadPresenter> {
        self { HeadToHeadPresenterImpl() }
     }
}
