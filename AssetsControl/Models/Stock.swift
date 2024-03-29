//
//  Stock.swift
//  My Assets
//
//  Created by Igoryok
//

import Foundation

class Stock: Identifiable, Codable, Equatable {
    static let apiKey = "MZ4NGAVYGGF4NACP"

    let id = UUID()
    let symbol: String

    var numberOfShares: Int
    var price: Double?

    private var prevPrice: Double?
    private var prevDate: Date?

    init(symbol: String, shares: Int) {
        self.symbol = symbol
        numberOfShares = shares
        price = nil
        prevPrice = nil
        prevDate = nil
    }

    static func == (lhs: Stock, rhs: Stock) -> Bool {
        lhs.id == rhs.id
    }

    func fetchPrices() {
        let url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=\(symbol)&apikey=\(Stock.apiKey)")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                print(error)
//                self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print(response)
//                self.handleServerError(response)
                return
            }
            do {
                guard let data, let json = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: [String: Any]]
                else {
                    print("error trying to convert data to JSON")
                    return
                }
                guard let timeSeries = json["Monthly Time Series"] as? [String: [String: String]] else {
                    print("error trying to convert \"Monthly Time Series\" to [String: [String: String]]")
                    return
                }

                let df = DateFormatter()
                df.dateFormat = "yyyy-MM"
                let thisMonthString = df.string(from: Date())
                let aYearAgoString: String = {
                    let year = DateComponents(year: -1)
                    return df.string(from: Calendar.current.date(byAdding: year, to: Date())!)
                }()

                guard let thisMonthKey = timeSeries.keys.first(where: { $0.contains(thisMonthString) }), let aYearAgoKey = timeSeries.keys.first(where: { $0.contains(aYearAgoString) }) else {
                    print("this month key failed")
                    return
                }
                guard let thisMonthData = timeSeries[thisMonthKey], let aYearAgoData = timeSeries[aYearAgoKey] else {
                    print("this month data failed")
                    return
                }
                let closeKey = "4. close"
                guard let thisMonthCloseString = thisMonthData[closeKey], let aYearAgoCloseString = aYearAgoData[closeKey] else {
                    print("this month close string failed")
                    return
                }
                guard let thisMonthClose = Double(thisMonthCloseString), let aYearAgoClose = Double(aYearAgoCloseString) else {
                    print("this month close failed")
                    return
                }
                self?.price = thisMonthClose
                self?.prevPrice = aYearAgoClose
                df.dateFormat = "yyyy-MM-dd"
                self?.prevDate = df.date(from: aYearAgoKey)!
//                CloudController.shared.financialData?.save()
                print(self?.price, self?.prevPrice)
            } catch {
                print("error")
            }
        }
        task.resume()
    }

    func fetchExchange() {
        let url = URL(string: "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_MONTHLY&symbol=\(symbol)&market=USD&apikey=\(Stock.apiKey)")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                //                self.handleClientError(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                //                self.handleServerError(response)
                return
            }
            do {
                guard let data, let json = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: [String: Any]]
                else {
                    print("error trying to convert data to JSON")
                    return
                }
                guard let timeSeries = json["Time Series (Digital Currency Monthly)"] as? [String: [String: String]] else {
                    print("error trying to convert \"Time Series (Digital Currency Monthly)\" to [String: [String: String]]")
                    return
                }

                let df = DateFormatter()
                df.dateFormat = "yyyy-MM"
                let thisMonthString = df.string(from: Date())
                let aYearAgoString: String = {
                    let year = DateComponents(year: -1)
                    return df.string(from: Calendar.current.date(byAdding: year, to: Date())!)
                }()

                guard let thisMonthKey = timeSeries.keys.first(where: { $0.contains(thisMonthString) }), let aYearAgoKey = timeSeries.keys.first(where: { $0.contains(aYearAgoString) }) else {
                    return
                }
                guard let thisMonthData = timeSeries[thisMonthKey], let aYearAgoData = timeSeries[aYearAgoKey] else {
                    return
                }
                let closeKey = "4b. close (USD)"
                guard let thisMonthCloseString = thisMonthData[closeKey], let aYearAgoCloseString = aYearAgoData[closeKey] else {
                    return
                }
                guard let thisMonthClose = Double(thisMonthCloseString), let aYearAgoClose = Double(aYearAgoCloseString) else {
                    return
                }
                self?.price = thisMonthClose
                self?.prevPrice = aYearAgoClose
                df.dateFormat = "yyyy-MM-dd"
                self?.prevDate = df.date(from: aYearAgoKey)!
//                CloudController.shared.financialData?.save()
                print(self?.price, self?.prevPrice)
            } catch {
                print("error")
            }
        }
        task.resume()
    }

    var annualInterestFraction: Double? {
        guard let prevD = prevDate, let prevP = prevPrice, let curr = price else { return nil }
        let yearsSinceDate = Date().timeIntervalSince(prevD) / TimeInterval.year
        return ((prevP / curr) - 1) / yearsSinceDate
    }
}
