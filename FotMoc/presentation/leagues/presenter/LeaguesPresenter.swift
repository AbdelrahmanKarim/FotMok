//
//  LeaguesPresenter.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//


import Foundation

protocol LeaguesPresenter {
    func attachView(_ view: LeaguesView)
    func detachView()
    func viewDidLoad()
    func search(query: String)
    func getLeaguesCount() -> Int
    func getLeague(at index: Int) -> League
    func didSelectLeague(at index: Int)
}
