//
//  CurrencyExchangeAPI.swift
//  AssetsControl
//
//  Created by Igoryok
//

import Alamofire
import Foundation

final class CurrencyExchangeAPI {
    // Singleton instance for shared usage
    static let shared = CurrencyExchangeAPI()

    private init() {}

    // Enum to define errors
    enum CurrencyExchangeError: Error {
        case invalidURL
        case networkError(Error)
        case invalidResponse
        case decodingError
        case rateNotFound
    }

    // Completion handler type alias for better readability
    typealias CompletionHandler = (Result<Double, CurrencyExchangeError>) -> Void

    // Fetch exchange rate between source and target currency
    func fetchExchangeRate(from source: String, to target: String, completion: @escaping CompletionHandler) {
        // Construct the API URL
        let urlString = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/\(source.lowercased()).json"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        // Perform the network request using Alamofire
        AF.request(urlRequest).responseData { response in
            switch response.result {
            case .failure(let error):
                // Handle network errors
                completion(.failure(.networkError(error)))

            case .success(let data):
                // Validate the response data
                guard response.response?.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                // Parse the JSON response
                do {
                    let decodedData = try JSONDecoder().decode(CurrencyResponse.self, from: data)

                    // Extract the rate for the target currency
                    if let rate = decodedData.currencies[target.lowercased()] {
                        completion(.success(rate))
                    } else {
                        completion(.failure(.rateNotFound))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }
    }

    struct CurrencyResponse: Codable {
        let date: String
        let currencies: [String: Double]

        // Custom CodingKeys to handle the dynamic source currency
        private struct DynamicCodingKeys: CodingKey {
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            var intValue: Int?
            init?(intValue _: Int) {
                nil
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

            // Decode the date
            date = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "date")!)

            // Find the source currency key dynamically
            var currenciesDict = [String: Double]()
            for key in container.allKeys {
                if key.stringValue != "date" {
                    let ratesContainer = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
                    for rateKey in ratesContainer.allKeys {
                        let rateValue = try ratesContainer.decode(Double.self, forKey: rateKey)
                        currenciesDict[rateKey.stringValue] = rateValue
                    }
                }
            }

            currencies = currenciesDict
        }
    }
}

// MARK: Cache manager by ChatGPT

//// Cache manager to store request time
//class CacheManager {
//    static let shared = CacheManager()
//    private let cacheTimeKey = "LastRequestTimeKey"
//    
//    // Check if the cached data is from the same day
//    func isCacheValid() -> Bool {
//        if let lastRequestDate = UserDefaults.standard.object(forKey: cacheTimeKey) as? Date {
//            return Calendar.current.isDateInToday(lastRequestDate)
//        }
//        return false
//    }
//    
//    func updateCacheTime() {
//        UserDefaults.standard.set(Date(), forKey: cacheTimeKey)
//    }
//}
//
//// Fetch data with caching logic
//func fetchData(url: String, completion: @escaping (DataResponse<Any, AFError>) -> Void) {
//    // Configure URLCache
//    let memoryCapacity = 50 * 1024 * 1024  // 50 MB
//    let diskCapacity = 100 * 1024 * 1024   // 100 MB
//    let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "customCachePath")
//    URLCache.shared = cache
//    
//    
//    
//    // Check cache validity
//    if CacheManager.shared.isCacheValid(),
//       let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: URL(string: url)!)) {
//        let response = AFDataResponse<Any>(request: nil, response: nil, data: cachedResponse.data, metrics: nil, serializationDuration: 0, result: .success(cachedResponse.data))
//        completion(response)
//    } else {
//        // Perform network request
//        AF.request(url).responseJSON { response in
//            if let data = response.data, let urlResponse = response.response {
//                // Cache the new response
//                let cachedResponse = CachedURLResponse(response: urlResponse, data: data)
//                URLCache.shared.storeCachedResponse(cachedResponse, for: response.request!)
//                
//                // Update the cache time
//                CacheManager.shared.updateCacheTime()
//            }
//            completion(response)
//        }
//    }
//}

// MARK: old method

//final class CurrencyExchangeAPI {
//    // Singleton instance for shared usage
//    static let shared = CurrencyExchangeAPI()
//
//    private init() {}
//
//    // Enum to define errors
//    enum CurrencyExchangeError: Error {
//        case invalidURL
//        case networkError(Error)
//        case invalidResponse
//        case decodingError
//        case rateNotFound
//    }
//
//    // Completion handler type alias for better readability
//    typealias CompletionHandler = (Result<Double, CurrencyExchangeError>) -> Void
//
//    // Fetch exchange rate between source and target currency
//    func fetchExchangeRate(from source: String, to target: String, completion: @escaping CompletionHandler) {
//        // Construct the API URL
//        let urlString = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/\(source.lowercased()).json"
//
//        // Ensure the URL is valid
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        // Create the URL request
//        let request = URLRequest(url: url)
//
//        // Perform the network request
//        let task = URLSession.shared.dataTask(with: request) { data, _, error in
//            // Handle network errors
//            if let error {
//                completion(.failure(.networkError(error)))
//                return
//            }
//
//            // Validate the response data
//            guard let data else {
//                completion(.failure(.invalidResponse))
//                return
//            }
//
//            // Parse the JSON response
//            do {
//                let decodedData = try JSONDecoder().decode(CurrencyResponse.self, from: data)
//
//                // Extract the rate for the target currency
//                if let rate = decodedData.currencies[target.lowercased()] {
//                    completion(.success(rate))
//                } else {
//                    completion(.failure(.rateNotFound))
//                }
//            } catch {
//                completion(.failure(.decodingError))
//            }
//        }
//
//        // Start the network request
//        task.resume()
//    }
//
//    struct CurrencyResponse: Codable {
//        let date: String
//        let currencies: [String: Double]
//
//        // Custom CodingKeys to handle the dynamic source currency
//        private struct DynamicCodingKeys: CodingKey {
//            var stringValue: String
//            init?(stringValue: String) {
//                self.stringValue = stringValue
//            }
//
//            var intValue: Int?
//            init?(intValue _: Int) {
//                nil
//            }
//        }
//
//        init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
//
//            // Decode the date
//            date = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: "date")!)
//
//            // Find the source currency key dynamically
//            var currenciesDict = [String: Double]()
//            for key in container.allKeys {
//                if key.stringValue != "date" {
//                    let ratesContainer = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
//                    for rateKey in ratesContainer.allKeys {
//                        let rateValue = try ratesContainer.decode(Double.self, forKey: rateKey)
//                        currenciesDict[rateKey.stringValue] = rateValue
//                    }
//                }
//            }
//
//            currencies = currenciesDict
//        }
//    }
//}
