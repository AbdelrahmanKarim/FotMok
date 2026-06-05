//
//  HomePresenter.swift
//  FotMoc
//
//  Created by Alaa Ayman on 05/06/2026.
//

import Foundation

protocol HomePresenter: AnyObject {
    func attachView(_ view: HomeView)
    func detachView()
    func selectSport(at index: Int, from sports: [SportCell])
}
