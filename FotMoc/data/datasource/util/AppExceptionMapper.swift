import Foundation
import Alamofire

extension AppException {
    static func map(_ error: Error) -> AppException {
        
        if let appException = error as? AppException {
            return appException
        }

     
        if let afError = error as? AFError {
         
            if let underlyingError = afError.underlyingError {
                let nsError = underlyingError as NSError
                if nsError.domain == NSURLErrorDomain {
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet,
                         NSURLErrorNetworkConnectionLost,
                         NSURLErrorCannotConnectToHost:
                        return .noInternetConnection
                    case NSURLErrorTimedOut:
                        return .timeout
                    default:
                        break
                    }
                }
            }

            // HTTP status code
            if let statusCode = afError.responseCode {
                switch statusCode {
                case 401, 403:   return .unauthorized
                case 404:        return .notFound
                case 500...599:  return .serverError(statusCode: statusCode)
                default:         return .custom(message: "Unexpected status code: \(statusCode)")
                }
            }
        }

        // Raw NSURLError (non-Alamofire paths)
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorCannotConnectToHost:
                return .noInternetConnection
            case NSURLErrorTimedOut:
                return .timeout
            default:
                break
            }
        }

        if error is DecodingError {
            return .decodingError
        }

        return .unknown
    }
}
