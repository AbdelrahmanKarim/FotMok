//
//  PresenterModule.swift
//  FotMoc
//
//  Created by abdelrahman karim on 05/06/2026.
//

import Factory

extension Container {
   
    var homePresenter: Factory<HomePresenter> {
        self { HomePresenterImpl(sportProvider: self.currentSportProvider()) }
    }
    
    var leagueDetailsPresenter: Factory<LeagueDetailsPresenter> {
        self { LeagueDetailsPresenterImpl(sportProvider: self.currentSportProvider()) }
    }
    
    var latestEventsPresenter: Factory<LatestPresenter> {
        self { LatestPresenterImpl(sportProvider: self.currentSportProvider()) }
    }
    var leaguesPresenter: Factory<LeaguesPresenter> {
        self { LeaguesPresenterImpl(sportProvider: self.currentSportProvider()) }
    }
    var favouritesPresenter: Factory<FavouritesPresenter> {
        self { FavouritesPresenterImpl() }
    }
    var liveMatchesPresenter: Factory<LiveMatchesPresenter> {
        self { LiveMatchesPresenterImpl(sportProvider: self.currentSportProvider()) }
     }
    var headToHeadPresenter: Factory<HeadToHeadPresenter> {
        self { HeadToHeadPresenterImpl() }
     }
    

    
}
