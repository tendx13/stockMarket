//
//  SavedPresenter.swift
//  stockMarket
//
//  Created by Денис Кононов on 16.07.2024.
//

import Foundation

class SavedPresenter:SavedPresenterProtocol {

    var view:SavedViewProtocol?
    
    var interactor:SavedInteractorProtocol?
    
    var router:SavedRouterProtocol?
    
    func presentFetchedStocks(_ stocks:Stock) {
        view?.showSavedStock(stock: stocks)
    }
    
    func fetchStocks() {
        interactor?.fetchStocks()
    }
    
    func deleteStock(symbol:String){
        interactor?.deleteStock(symbol: symbol)
    }
    
    func showDetail(for symbol: String) {
        router?.navigateToDetail(with: symbol)
    }
    
}
