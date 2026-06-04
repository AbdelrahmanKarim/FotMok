//
//  AppExceptionMapper.swift
//  FotMoc
//
//  Created by abdelrahman karim on 04/06/2026.
//
//

//
import Foundation
import Alamofire

extension AppException {
    static func map(_ error: Error) -> AppException {
        if let appException = error as? AppException {
            return appException
        }
        
        if let afError = error as? AFError {
            if let statusCode = afError.responseCode {
                switch statusCode {
                case 401, 403:
                    return .unauthorized
                case 404:
                    return .notFound
                case 500...599:
                    return .serverError(statusCode: statusCode)
                default:
                    return .custom(message: "Received unexpected status code: \(statusCode)")
                }
            }
        }
        
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorNetworkConnectionLost, NSURLErrorCannotConnectToHost:
                return .noInternetConnection
            case NSURLErrorTimedOut:
                return .timeout
            default:
                return .unknown
            }
        }
            
        if error is DecodingError {
            return .decodingError
        }
        return .unknown
    }
}
