//
//  HomePresenterImpl.swift
//  FotMoc
//
//  Created by Alaa Ayman on 05/06/2026.
//

import Foundation
import Factory

class HomePresenterImpl: HomePresenter {
    
    private weak var view: HomeView?
    private let sportProvider: CurrentSportProvider
    
    init(sportProvider: CurrentSportProvider) {
            self.sportProvider = sportProvider
    }
    func attachView(_ view: HomeView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func selectSport(at index: Int, from sports: [SportCell]) {
            guard index >= 0 && index < sports.count else { return }
            let selectedCell = sports[index]
            
            let resolvedSportType = SportType(rawValue: selectedCell.title) ?? .football
            
          
            sportProvider.selectedSport = resolvedSportType
            
            print("Sport provider updated to: \(sportProvider.selectedSport.rawValue)")
            
            view?.navigateToLeagues(with: resolvedSportType)
        }
}
