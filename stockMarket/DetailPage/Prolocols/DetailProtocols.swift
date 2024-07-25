//
//  DetailProtocols.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import Foundation
import UIKit
import DGCharts

// MARK: - View Protocol

protocol DetailViewProtocol: AnyObject {
    // Presenter -> View
    func showDetail(detail: DetailElement)
    func showHistoricalData(data: [ChartDataEntry])
}

// MARK: - Presenter Protocol

protocol DetailPresenterProtocol: AnyObject {
    // View -> Presenter
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorProtocol? { get set }
    var router: DetailRouterProtocol? { get set }
    
    func showDetail()
    func showHistoricalData(for:String)
    func updateDetail(detail: DetailElement)
    func updateHistoricalData(data: [ChartDataEntry])
}

// MARK: - Interactor Protocol

protocol DetailInteractorProtocol: AnyObject {
    // Presenter -> Interactor
    var presenter: DetailPresenterProtocol? { get set }
    var stockSymbol: String { get set }
    
    func loadDetail()
    func loadHistoricalData(for:String)
}

// MARK: - Router Protocol

protocol DetailRouterProtocol: AnyObject {
    // Presenter -> Router
    static func createDetailView(with symbol: String) -> DetailViewController
}
