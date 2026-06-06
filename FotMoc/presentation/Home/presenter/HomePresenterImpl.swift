//
//  HomePresenterImpl.swift
//  FotMoc
//
//  Created by Alaa Ayman on 05/06/2026.
//

import Foundation
import Factory
import UIKit

class HomePresenterImpl: HomePresenter {

    private weak var view: HomeView?
    private let sportProvider: CurrentSportProvider

    private let themeKey    = "isDarkMode"
    private let languageKey = "AppLanguage"

    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
    }


    func attachView(_ view: HomeView) {
        self.view = view
        let isDark = currentThemeIsDark()
        view.updateThemeIcon(isDark: isDark)
        view.applyTheme(isDark: isDark)
    }

    func detachView() {
        self.view = nil
    }

  

    func selectSport(at index: Int, from sports: [SportCell]) {
        guard index >= 0 && index < sports.count else { return }
        let resolvedSportType = SportType(rawValue: sports[index].title) ?? .football
        sportProvider.selectedSport = resolvedSportType
        view?.navigateToLeagues(with: resolvedSportType)
    }

  
    func toggleTheme() {
        let newIsDark = !currentThemeIsDark()
        UserDefaults.standard.set(newIsDark, forKey: themeKey)
        view?.applyTheme(isDark: newIsDark)
        view?.updateThemeIcon(isDark: newIsDark)
    }

    func currentThemeIsDark() -> Bool {
        guard UserDefaults.standard.object(forKey: themeKey) != nil else {
            return UITraitCollection.current.userInterfaceStyle == .dark
        }
        return UserDefaults.standard.bool(forKey: themeKey)
    }

   

    func selectLanguage(_ code: String) {
        UserDefaults.standard.set(code, forKey: languageKey)
      
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        view?.showRestartAlert()
    }

    func currentLanguageCode() -> String {
        return UserDefaults.standard.string(forKey: languageKey)
            ?? Locale.current.language.languageCode?.identifier
            ?? "en"
    }
}
