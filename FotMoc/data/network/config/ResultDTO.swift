//
//  Result.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import Foundation

struct ResultDTO<T: Decodable>: Decodable {
    let success: Int?
    let result: T?
}
