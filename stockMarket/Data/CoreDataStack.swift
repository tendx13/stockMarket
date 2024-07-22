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
      
      func saveStockToCoreData(_ stock: StockElement) {
          let context = persistentContainer.viewContext
          guard let entity = NSEntityDescription.entity(forEntityName: "Stocks", in: context) else{return}
          let stockManager = NSManagedObject(entity: entity, insertInto: context)
          stockManager.setValue(stock.name, forKey: "name")
          stockManager.setValue(stock.symbol, forKey: "symbol")
          stockManager.setValue(stock.change, forKey: "change")
          stockManager.setValue(stock.price, forKey: "price")
          
          saveContext()
      }
    
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
