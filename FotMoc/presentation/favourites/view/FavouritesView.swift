//
//  FavouritesView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation

protocol FavouritesView: AnyObject {
    func showLoading()
    func hideLoading()
    func showFavourites(_ leagues: [League])
    func showError(_ message: String)
    func showEmptyState(isHidden: Bool)
    
    
}
