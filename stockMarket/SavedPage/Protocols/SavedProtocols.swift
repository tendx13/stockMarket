//
//  SavedProtocols.swift
//  stockMarket
//
//  Created by Денис Кононов on 16.07.2024.
//

import Foundation

protocol SavedViewProtocol: AnyObject {
    // Presenter -> View
    
    var stocks:Stock {get set}
    func showSavedStock(stock:Stock)
    
}


protocol SavedPresenterProtocol: AnyObject {
    // View -> Presenter
    
    var view: SavedViewProtocol? {get set}
    var interactor: SavedInteractorProtocol? {get set}
    var router: SavedRouterProtocol? {get set}
    
    func fetchStocks()
    func presentFetchedStocks(_ stocks:Stock)
    func deleteStock(symbol:String)
    func showDetail(for symbol: String)
    
}


protocol SavedInteractorProtocol: AnyObject {
    // Presenter -> Interactor
    var presenter: SavedPresenterProtocol? {get set}
    func fetchStocks()
    func deleteStock(symbol:String)
    
}

protocol SavedRouterProtocol: AnyObject {
    // Presenter -> Router
    func navigateToDetail(with symbol:String)
    static func createStockView() -> SavedViewController
}


