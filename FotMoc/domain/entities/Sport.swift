//
//  Sport.swift
//  FotMoc
//
//  Created by Alaa Ayman on 01/06/2026.
//
enum SportType: String {
    case football = "Soccer"
    case basketball = "Basketball"
    case cricket = "Cricket"
    case tennis = "Tennis"
    
   
    var iconAssetName: String {
        switch self {
        case .football: return "icon_soccer"
        case .basketball: return "icon_basketball"
        case .cricket: return "icon_cricket"
        case .tennis: return "icon_tennis"
        }
    }
}
