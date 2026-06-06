//
//  LeagueDetailsPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import Factory
import Network

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
    @Injected(\.saveFavouriteLeagueUseCase) private var saveUseCase
    @Injected(\.removeFavouriteLeagueUseCase) private var removeUseCase
    @Injected(\.getFavouriteLeaguesUseCase) private var getFavUseCase
    private var currentLeague: League?
    private var isFavourite: Bool = false
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = true
    private var pendingLeagueId: String?

    func attachView(_ view: LeagueDetailsView) {
        self.view = view
        startMonitoring()
    }

    func detachView() {
        self.view = nil
        monitor?.cancel()
        monitor = nil
    }
    func retryLoading() {
            guard let id = pendingLeagueId else { return }
            retryAll(leagueId: id)
        }
   
    private func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            let wasConnected = self.isConnected
            self.isConnected = path.status == .satisfied

            DispatchQueue.main.async {
                if self.isConnected && !wasConnected {
                    // just reconnected — auto retry
                    if let id = self.pendingLeagueId {
                        self.view?.hideNoInternet()
                        self.retryAll(leagueId: id)
                    }
                } else if !self.isConnected {
                    self.view?.showNoInternet()
                }
            }
        }
        monitor?.start(queue: DispatchQueue(label: "NetworkMonitor"))
    }

    private func retryAll(leagueId: String) {
        loadLeagueDetails(leagueId: leagueId)
        loadLeagueContent(leagueId: leagueId)
    }

  
    private func guardConnectivity(leagueId: String) -> Bool {
        pendingLeagueId = leagueId
        if !isConnected {
            view?.showNoInternet()
            return false
        }
        return true
    }
    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
    }
    
 
    
    func loadLeagueDetails(leagueId: String) {
            guard guardConnectivity(leagueId: leagueId) else { return }
                Task { @MainActor in
                    do {
                        let league = try await leagueDetailsUseCase.execute(leagueId: leagueId)
                        self.currentLeague = league
                        view?.displayLeagueInfo(name: league.name, country: league.country?.name ?? "")
                        let favs = try await getFavUseCase.execute()
                        self.isFavourite = favs.contains(where: { $0.id == leagueId })
                        view?.updateFavouriteIcon(isFavourite: self.isFavourite)
                    } catch {
                        view?.displayError(message: "Could not load League Info : \(error.localizedDescription)")
                    }
                }
            }
        
        func toggleFavourite() {
            guard let league = currentLeague else { return }
            
            Task { @MainActor in
                do {
                    if isFavourite {
                        try await removeUseCase.execute(leagueId: league.id)
                        self.isFavourite = false
                    } else {
                        try await saveUseCase.execute(league: league)
                        self.isFavourite = true
                    }
                    view?.updateFavouriteIcon(isFavourite: self.isFavourite)
                } catch {
                    view?.displayError(message: "Could not update favourite: \(error.localizedDescription)")
                }
            }
        }
    func didSelectTeam(teamId: String) {
            let targetLeagueId = currentLeague?.id ?? ""
            view?.navigateToTeamDetails(teamId: teamId, leagueId: targetLeagueId)
        }
        
        func didSelectPlayer(playerId: String) {
            view?.navigateToPlayerProfile(playerId: playerId)
        }
    func loadLeagueContent(leagueId: String) {
            guard guardConnectivity(leagueId: leagueId) else { return }
            view?.showLoading()
            Task { @MainActor in
                let sport = sportProvider.selectedSport
                do {
                    let upcoming = try await upcomingUseCase.execute(leagueId: leagueId)
                    let latest = try await latestUseCase.execute(leagueId: leagueId)
                    let data: [Any]
                    switch sport {
                    case .tennis:
                        data = (try? await leaguePlayersUseCase.execute(leagueId: leagueId)) ?? []
                    default:
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
        guard guardConnectivity(leagueId: leagueId) else { return }
      
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
        guard guardConnectivity(leagueId: leagueId) else { return }
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
