//
//  NewsRouter.swift
//  stockMarket
//
//  Created by Денис Кононов on 13.07.2024.
//

import Foundation
import UIKit

// MARK: - NewsRouter

class NewsRouter: NewsRouterProtocol {
    
    // MARK: - NewsRouterProtocol
    
    static func createNewsView() -> NewsViewController {
        let viewController = NewsViewController()
        let presenter: NewsPresenterProtocol = NewsPresenter()
        viewController.presenter = presenter
        viewController.presenter?.view = viewController
        viewController.presenter?.interactor = NewsInteractor()
        viewController.presenter?.interactor?.presenter = presenter
        viewController.presenter?.router = NewsRouter()
        return viewController
    }
}
