//
//  CoreDataStack.swift
//  stockMarket
//
//  Created by Денис Кононов on 16.07.2024.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}
    
    // MARK: - Persistent Container

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Fetch Stock
    
    /// Fetches a stock from CoreData by its symbol.
    /// - Parameter symbol: The symbol of the stock to fetch.
    /// - Returns: The fetched stock as an `NSManagedObject`, or `nil` if not found.
    func fetchStockBySymbol(_ symbol: String) -> NSManagedObject? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Stocks")
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do {
            let stocks = try persistentContainer.viewContext.fetch(fetchRequest)
            return stocks.first as? NSManagedObject
        } catch {
            print("Failed to fetch stock by symbol: \(error)")
            return nil
        }
    }
    
    // MARK: - Save Stock
    
    /// Saves a stock to CoreData.
    /// - Parameter stock: The stock to save.
    func saveStockToCoreData(_ stock: StockElement) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Stocks", in: context) else { return }
        let stockManager = NSManagedObject(entity: entity, insertInto: context)
        stockManager.setValue(stock.name, forKey: "name")
        stockManager.setValue(stock.symbol, forKey: "symbol")
        stockManager.setValue(stock.change, forKey: "change")
        stockManager.setValue(stock.price, forKey: "price")
        
        saveContext()
    }
    
    // MARK: - Save Context
    
    /// Saves the current context if there are changes.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Delete Stock
    
    /// Deletes a stock from CoreData by its symbol.
    /// - Parameter symbol: The symbol of the stock to delete.
    func deleteStockBySymbol(_ symbol: String) {
        let fetchRequest: NSFetchRequest<Stocks> = Stocks.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        do {
            let fetchedStocks = try persistentContainer.viewContext.fetch(fetchRequest)
            for stock in fetchedStocks {
                persistentContainer.viewContext.delete(stock)
            }
            saveContext()
        } catch {
            print("Failed to delete stock by symbol: \(error)")
        }
    }
}
