//
//  LeagueDetailsPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import Factory


class LeagueDetailsPresenterImpl: LeagueDetailsPresenter {
   
    
    private weak var view: LeagueDetailsView?
    private let sportProvider: CurrentSportProvider
    
    @Injected(\.getLeagueTableStandingsUseCase) private var standingsUseCase
    @Injected(\.getLeagueUpcomingMatchesUseCase) private var upcomingUseCase
    @Injected(\.getLeagueLatestMatchesUseCase) private var latestUseCase
    @Injected(\.getLeagueTeamsUseCase) private var leagueTeamsUseCase
    @Injected(\.getLeaguePlayersUseCase) private var leaguePlayersUseCase
    @Injected(\.getLeagueDetailsUseCase) private var leagueDetailsUseCase
    @Injected(\.getLeagueTopScorersUseCase) private var topScorersUseCase
    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
    }
    
    func attachView(_ view: LeagueDetailsView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
   
    func loadLeagueDetails(leagueId: String) {
        Task { @MainActor in
            do {
                let league = try await leagueDetailsUseCase.execute(leagueId: leagueId)
                view?.displayLeagueInfo(name: league.name, country: league.country?.name ?? "")
            } catch {
                print("Could not load league info: \(error)")
            }
        }
    }
    func loadLeagueContent(leagueId: String) {
        view?.showLoading()
        Task { @MainActor in
            
            let isTennis = sportProvider.selectedSport == .tennis
            
            do {
          
                let upcoming = try await upcomingUseCase.execute(leagueId: leagueId)
                let latest = try await latestUseCase.execute(leagueId: leagueId)
                
                let data: [Any]
                if isTennis {
                    data = try await leaguePlayersUseCase.execute(leagueId: leagueId)
                } else {
                    data = try await leagueTeamsUseCase.execute(leagueId: leagueId)
                    
                }
                
                view?.hideLoading()
                view?.displayOverviewData(upcoming: upcoming, latest: latest, teamsOrPlayers: data)
            } catch {
                view?.hideLoading()
                view?.displayError(message: error.localizedDescription)
            }
        }
    }
    func loadTableContent(leagueId: String) {
      
            view?.showLoading()
            
            Task { @MainActor in
                do {
                    
                    let standingsRows = try await standingsUseCase.execute(leagueId: leagueId)
                    
                    view?.hideLoading()
                    view?.displayTableData(standings: standingsRows)
                    
                } catch {
                    view?.hideLoading()
                    view?.displayError(message: error.localizedDescription)
                }
            }
        }
  

    func loadTopScorers(leagueId: String) {
        view?.showLoading()
        Task { @MainActor in
            do {
                let scorers = try await topScorersUseCase.execute(leagueId: leagueId)
                view?.hideLoading()
                view?.displayTopScorers(scorers: scorers)
                
            } catch {
                view?.hideLoading()
                view?.displayError(message: error.localizedDescription)
            }
        }
    }
    func didTapBack() {
            view?.navigateBack()
        }
    func didTapShowMoreLatest() {
        view?.navigateToLatestMatches()
    }
    func didSelectMatch(_ match: Match, leagueId: String) {
        let homeId = extractId(from: match.homeCompetitor)
        let awayId = extractId(from: match.awayCompetitor)
        let title  = "\(extractName(from: match.homeCompetitor)) vs \(extractName(from: match.awayCompetitor))"
        view?.navigateToH2H(teamId1: homeId, teamId2: awayId, leagueId: leagueId, title: title)
    }

    private func extractId(from competitor: Competitor) -> String {
        switch competitor {
        case .team(let t):   return t.id
        case .player(let p): return p.id
        }
    }

    private func extractName(from competitor: Competitor) -> String {
        switch competitor {
        case .team(let t):   return t.name
        case .player(let p): return p.name
        }
    }
}
