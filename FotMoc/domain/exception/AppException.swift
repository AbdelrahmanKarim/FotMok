//
//  AppException.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//
import Foundation


enum AppException: Error, Equatable {

    case noInternetConnection
    case timeout
    case serverError(statusCode: Int)
    case unauthorized
    case notFound
    case decodingError
    case noData
    case custom(message: String)
    case unknown
}

extension AppException: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "Please check your internet connection and try again."
            
        case .timeout:
            return "The connection timed out. Please try again later."
            
        case .serverError(let statusCode):
            return "We are experiencing server issues. Please try again later."
            
        case .unauthorized:
            return "Your session has expired. Please log in again."
            
        case .notFound:
            return "The requested information could not be found."
            
        case .decodingError:
            return "We encountered an issue displaying the data. Please try again."
            
        case .noData:
            return "No results were found."
            
        case .custom(let message):
            return message 
            
        case .unknown:
            return "An unexpected error occurred. Please try again."
        }
    }
}

