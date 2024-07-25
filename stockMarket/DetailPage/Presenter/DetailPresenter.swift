//
//  DetailPresenter.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import Foundation
import DGCharts

class DetailPresenter: DetailPresenterProtocol {
    
    // MARK: - Properties
    
    var stockSymbol: String
    var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol?
    var router: DetailRouterProtocol?
    
    // MARK: - Initialization
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
    
    // MARK: - Methods
    
    func showDetail() {
        interactor?.loadDetail()
    }
    
    func showHistoricalData(for period:String) {
        interactor?.loadHistoricalData(for: period)
    }
    
    func updateDetail(detail: DetailElement) {
        view?.showDetail(detail: detail)
    }
    
    func updateHistoricalData(data: [ChartDataEntry]) {
        view?.showHistoricalData(data: data)
    }
}
