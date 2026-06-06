//
//  HeadToHeadView.swift
//  FotMoc
//
//  Created by abdelrahman karim on 03/06/2026.
//

import Foundation


protocol HeadToHeadView: AnyObject {
    func showLoading()
    func hideLoading(then completion: (() -> Void)?)
    func displayUpcomingMatch(_ match: Match?)
    func displayRecentForm(firstTeam: TeamRecentForm, secondTeam: TeamRecentForm)
    func displayPreviousMatches(_ matches: [Match])
    func displayOverallRecord(_ record: HeadToHeadRecord)
    func displayError(message: String)
    func navigateBack()
    func showNoInternet()
     func hideNoInternet()
}
