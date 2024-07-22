//
//  DetailRouter.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import Foundation
import UIKit

class DetailRouter: DetailRouterProtocol {
    
    // MARK: - Methods
    
    static func createDetailView(with symbol: String) -> DetailViewController {
        let viewController = DetailViewController()
        let presenter: DetailPresenterProtocol = DetailPresenter(stockSymbol: symbol)
        viewController.presenter = presenter
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = DetailInteractor(stockSymbol: symbol)
        viewController.presenter?.interactor?.presenter = presenter
        return viewController
    }
}
