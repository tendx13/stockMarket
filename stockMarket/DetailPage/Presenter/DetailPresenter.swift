//
//  DetailPresenter.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import Foundation
import DGCharts

class DetailPresenter:DetailPresenterProtocol {
   
    var stockSymbol: String
    
    var view:DetailViewProtocol?
    
    var interactor:DetailInteractorProtocol?
    
    var router:DetailRouterProtocol?
    
    func showDetail() {
        interactor?.loadDetail()
    }
    func showHistoricalData() {
        interactor?.loadHistoricalData()
    }
    
    func updateDetail(detail: DetailElement) {
        view?.showDetail(detail: detail)
    }
    func updateHistoricalData(data:[ChartDataEntry]) {
        view?.showHistoricalData(data: data)
    }
    init(stockSymbol: String) {
            self.stockSymbol = stockSymbol
        }
}
