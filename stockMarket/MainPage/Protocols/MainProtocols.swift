//
//  MainProtocols.swift
//  stockMarket
//
//  Created by Денис Кононов on 03.07.2024.
//

import Foundation

// MARK: - MainViewProtocol

protocol MainViewProtocol: AnyObject {
    // Presenter -> View
    
    func showStock(stock: Stock)
}

// MARK: - MainPresenterProtocol

protocol MainPresenterProtocol: AnyObject {
    // View -> Presenter
    
    var view: MainViewProtocol? { get set }
    var interactor: MainInteractorProtocol? { get set }
    var router: MainRouterProtocol? { get set }
    
    func showStock()
    func updateStock(stock: Stock)
    func getCurrentDate(locale: Locale) -> String
    func showDetail(for symbol: String)
    func saveStock(stock: StockElement)
}

// MARK: - MainInteractorProtocol

protocol MainInteractorProtocol: AnyObject {
    // Presenter -> Interactor
    
    var presenter: MainPresenterProtocol? { get set }
    
    func loadStock()
    func getCurrentDate(locale: Locale) -> String
    func saveStock(stock: StockElement)
}

// MARK: - MainRouterProtocol

protocol MainRouterProtocol: AnyObject {
    // Presenter -> Router
    
    func navigateToDetail(with symbol: String)
    func navigateToSaved()
    func navigateToNews()
    static func createStockView(viewController: ViewController)
}
