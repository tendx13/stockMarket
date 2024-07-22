//
//  SavedInteractor.swift
//  stockMarket
//
//  Created by Денис Кононов on 16.07.2024.
//

import Foundation
import CoreData

// MARK: - SavedInteractor

class SavedInteractor: SavedInteractorProtocol {

    // MARK: - Properties

    var presenter: SavedPresenterProtocol?

    // MARK: - Fetching Stocks

    func fetchStocks() {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        do {
            let fetchedStocks = try context.fetch(fetchRequest)
            let stocks = fetchedStocks.map { stock -> StockElement in
                return StockElement(
                    symbol: stock.symbol ?? "",
                    name: stock.name,
                    change: stock.change,
                    price: stock.price,
                    changesPercentage: 0.0
                )
            }
            presenter?.presentFetchedStocks(stocks)
        } catch {
            print("Error Core Data: \(error)")
        }
    }

    // MARK: - Deleting Stock

    func deleteStock(symbol: String) {
        CoreDataStack.shared.deleteStockBySymbol(symbol)
    }
}
