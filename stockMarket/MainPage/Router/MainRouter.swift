//
//  MainRouter.swift
//  stockMarket
//
//  Created by Денис Кононов on 06.07.2024.
//

import Foundation

// MARK: - MainRouterProtocol

class MainRouter: MainRouterProtocol {
    
    // MARK: - Properties
    
    weak var viewController: ViewController?
    var newsVC: NewsViewController?
    
    // MARK: - Static Methods
    
    static func createStockView(viewController: ViewController) {
        let presenter: MainPresenterProtocol = MainPresenter()
        viewController.presenter = presenter
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = MainInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        let router = MainRouter()
        router.viewController = viewController
        viewController.presenter?.router = router
    }
    
    // MARK: - Navigation Methods
    
    func navigateToDetail(with symbol: String) {
        let detailVC = DetailRouter.createDetailView(with: symbol)
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return context.maximumDetentValue * 0.95
            })]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        
        newsVC?.dismiss(animated: true) {
            self.viewController?.present(detailVC, animated: true, completion: nil)
            detailVC.onDismiss = { [weak self] in
                self?.navigateToNews()
            }
        }
    }
    
    func navigateToNews() {
        guard let viewController = self.viewController else {
            print("Error: viewController is nil when presenting newsVC")
            return
        }
        
        newsVC = NewsRouter.createNewsView()
        if let sheet = newsVC?.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return 50
            }), .medium(), .custom(resolver: { context in
                return context.maximumDetentValue * 0.95
            })]
            sheet.prefersGrabberVisible = true
            sheet.largestUndimmedDetentIdentifier = .medium
            newsVC?.isModalInPresentation = true
        }
        
        DispatchQueue.main.async {
            viewController.present(self.newsVC!, animated: true)
        }
    }
    
    func navigateToSaved() {
        let savedVC = SavedRouter.createStockView()
        viewController?.navigationController?.pushViewController(savedVC, animated: true)
    }
    
}
