//
//  MainPresenter.swift
//  stockMarket
//
//  Created by Денис Кононов on 03.07.2024.
//

import Foundation

final class MainPresenter:MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol?
    var router: MainRouterProtocol?
    
    
    
    
    func showStock() {
        interactor?.loadStock()
    }
    
    func updateStock(stock: Stock) {
        view?.showStock(stock: stock)
    }
   
    func getCurrentDate(locale: Locale) -> String {
        interactor?.getCurrentDate(locale: locale) ?? ""
    }
    
    func showDetail(for symbol: String) {
        router?.navigateToDetail(with: symbol)
    }
    func saveStock(stock: StockElement) {
        interactor?.saveStock(stock: stock)
    }
}
