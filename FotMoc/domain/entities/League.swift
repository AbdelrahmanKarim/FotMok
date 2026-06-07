//
//  League.swift
//  FotMoc
//
//  Created by Alaa Ayman on 01/06/2026.
//
import Foundation
struct League {
    let id: String
    let name: String
    let logoUrl: URL?
    let sport: SportType
    let country: Country?
    let season: String
    
    
    let sportContext: LeagueSportContext
}

enum LeagueSportContext {
    case teamSport
    case tennis(surface: String)
}
