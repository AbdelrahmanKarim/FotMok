//
//  FavouritesPresenterImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation
import Factory

class FavouritesPresenterImpl: FavouritesPresenter {
    private weak var view: FavouritesView?
    @Injected(\.getFavouriteLeaguesUseCase) private var getFavouriteLeaguesUseCase: GetFavouriteLeaguesUseCase
    @Injected(\.removeFavouriteLeagueUseCase)private var removeFavouriteLeagueUseCase: RemoveFavouriteLeagueUseCase
    
    private var favourites: [League] = []
    
    
    func attachView(_ view: FavouritesView){
        self.view = view
    }
    func detachView(){
        self.view = nil
    }
    func viewWillAppear() {
        fetchFavourites()
    }
    
    private func fetchFavourites() {
            DispatchQueue.main.async { [weak self] in
                self?.view?.showLoading()
            }
            Task {
                do {
                    let leagues = try await getFavouriteLeaguesUseCase.execute()
                    DispatchQueue.main.async { [weak self] in
                        self?.favourites = leagues
                        self?.view?.hideLoading()
                        self?.view?.showEmptyState(isHidden: !leagues.isEmpty)
                        self?.view?.showFavourites(leagues)
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.view?.hideLoading()
                        self?.view?.showError(error.localizedDescription)
                    }
                }
            }
        }
    
    func getLeaguesCount() -> Int { return favourites.count }
    func getLeague(at index: Int) -> League { return favourites[index] }
    
    func removeFavourite(at index: Int) {
        let league = favourites[index]
        Task {
            try? await removeFavouriteLeagueUseCase.execute(leagueId: league.id)
            fetchFavourites()
        }
    }
    
    func didSelectLeague(at index: Int) {
        let league = favourites[index]
    }
}
