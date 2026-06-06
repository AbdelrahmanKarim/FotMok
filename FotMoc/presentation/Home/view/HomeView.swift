//
//  HomeView.swift
//  FotMoc
//
//  Created by Alaa Ayman on 05/06/2026.
//

import Foundation


protocol HomeView: AnyObject {
    func navigateToLeagues(with sport: SportType)
    func updateThemeIcon(isDark: Bool)
    func applyTheme(isDark: Bool)
    func showRestartAlert()
}

