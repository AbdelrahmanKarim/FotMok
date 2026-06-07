//
//  NetworkManager.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

import Foundation
import Alamofire

class NetworkManager {
    
    private let baseURL = Secrets.baseURL
    private let apiKey = Secrets.apiKey
    
    func fetch<T: Decodable>(sport: String, parameters: [String: Any]) async throws -> ResultDTO<T> {
        
        let url = "\(baseURL)/\(sport)/"
        var finalParameters = parameters
        finalParameters["APIkey"] = apiKey
        let request = AF.request(url, method: .get, parameters: finalParameters)
        let dataResponse = await request.serializingDecodable(ResultDTO<T>.self).response
        return try dataResponse.result.get()
    }
    enum Secrets {
        
        static var apiKey: String {
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
                fatalError("API_KEY not found in Info.plist")
            }
            return apiKey
        }
        
        static var baseURL: String {
            guard let host = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else {
                fatalError("BASE_URL not found in Info.plist")
            }
            return "https://\(host)/"
        }
    }
}
