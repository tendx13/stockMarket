// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let historicalData = try? JSONDecoder().decode(HistoricalData.self, from: jsonData)

import Foundation

// MARK: - HistoricalData
struct HistoricalData: Codable {
    let symbol: String?
    let historical: [Historical]
}

// MARK: - Historical
struct Historical: Codable {
    let date: String?
    let historicalOpen, high, low, close: Double?
    let adjClose: Double?
    let volume, unadjustedVolume: Int?
    let change, changePercent, vwap: Double?
    let label: String?
    let changeOverTime: Double?

    enum CodingKeys: String, CodingKey {
        case date
        case historicalOpen = "open"
        case high, low, close, adjClose, volume, unadjustedVolume, change, changePercent, vwap, label, changeOverTime
    }
}
