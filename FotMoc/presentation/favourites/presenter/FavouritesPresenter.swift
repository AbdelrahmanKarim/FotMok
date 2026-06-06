//
//  FavouritesPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol FavouritesPresenter {
    func attachView(_ view: FavouritesView)
    func detachView()
    func viewWillAppear()
    func getLeaguesCount() -> Int
    func getLeague(at index: Int) -> League
    func removeFavourite(at index: Int)
    func didSelectLeague(at index: Int)
}
