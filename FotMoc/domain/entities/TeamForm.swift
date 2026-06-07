//
//  TeamForm.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

import Foundation



struct TeamRecentForm {
    let teamId: String
    let teamName: String
    let logoUrl: URL?
    let form: [MatchOutcome]
}
enum MatchOutcome: String {
    case win = "W"
    case draw = "D"
    case loss = "L"
}
