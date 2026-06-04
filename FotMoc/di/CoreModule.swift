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
}

extension Container {
    var currentSportProvider: Factory<CurrentSportProvider> {
        self { CurrentSportProvider() }.singleton
    }
}
