// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stock = try? JSONDecoder().decode(Stock.self, from: jsonData)

import Foundation

// MARK: - StockElement
struct StockElement: Codable {
    let symbol: String
    let name: String?
    let change, price, changesPercentage: Double
}

typealias Stock = [StockElement]
