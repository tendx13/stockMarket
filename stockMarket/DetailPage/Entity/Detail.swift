// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let detail = try? JSONDecoder().decode(Detail.self, from: jsonData)

import Foundation

// MARK: - DetailElement
struct DetailElement: Codable {
    let symbol: String?
    let price, beta: Double?
    let volAvg, mktCap: Int?
    let lastDiv: Double?
    let range: String?
    let changes: Double?
    let companyName, currency, cik, isin: String?
    let cusip, exchange, exchangeShortName, industry: String?
    let website: String?
    let description, ceo, sector, country: String?
    let fullTimeEmployees, phone, address, city: String?
    let state, zip: String?
    let dcfDiff, dcf: Double?
    let image: String?
    let ipoDate: String?
    let defaultImage, isEtf, isActivelyTrading, isAdr: Bool?
    let isFund: Bool?
}

typealias Detail = [DetailElement]

