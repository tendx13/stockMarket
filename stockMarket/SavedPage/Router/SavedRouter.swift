//
//  SavedRouter.swift
//  stockMarket
//
//  Created by Денис Кононов on 16.07.2024.
//

import Foundation

class SavedRouter: SavedRouterProtocol {
    
    weak var viewController: SavedViewController?
    
    static func createStockView() -> SavedViewController {
        let viewController = SavedViewController()
        let presenter: SavedPresenterProtocol = SavedPresenter()
        let router = SavedRouter()
        router.viewController = viewController
        viewController.presenter = presenter
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = SavedInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.router = router
        return viewController
    }
    
    func navigateToDetail(with symbol: String) {
        let detailVC = DetailRouter.createDetailView(with: symbol)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
