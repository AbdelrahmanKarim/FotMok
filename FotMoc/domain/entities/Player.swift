//
//  Player.swift
//  FotMoc
//
//  Created by Alaa Ayman on 01/06/2026.
//
import Foundation
struct Player {
    let id: String
    let name: String
    let imageUrl: URL?
    let nationality: String?
    let age: Int?
    let sportDetails: PlayerSportContext
}
 
enum PlayerSportContext {
    case football(teamId: String, position: String)
    case basketball(teamId: String, position: String)
    case cricket(teamId: String, role: String)
    case tennis(rank: Int?, plays: String?)
}
