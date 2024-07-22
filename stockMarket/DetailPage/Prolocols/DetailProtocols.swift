//
//  DetailProtocols.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import Foundation
import UIKit
import DGCharts

protocol DetailViewProtocol: AnyObject {
    // Presenter -> View
    func showDetail(detail:DetailElement)
    func showHistoricalData(data:[ChartDataEntry])
}

protocol DetailPresenterProtocol: AnyObject {
    // View -> Presenter
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    
    func showDetail()
    func showHistoricalData()
    func updateDetail(detail:DetailElement)
    func updateHistoricalData(data:[ChartDataEntry])
    
    
}

protocol DetailInteractorProtocol: AnyObject {
    // Presenter -> Interactor
    var presenter:DetailPresenterProtocol? {get set}
    var stockSymbol: String {get set}
    func loadDetail()
    func loadHistoricalData()
    
}

protocol DetailRouterProtocol: AnyObject {
    // Presenter -> Router
    static func createDetailView(with symbol:String) -> DetailViewController
}
