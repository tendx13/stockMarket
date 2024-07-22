//
//  NewsProtocols.swift
//  stockMarket
//
//  Created by Денис Кононов on 13.07.2024.
//

import Foundation
import UIKit

protocol NewsViewProtocol: AnyObject {
    // Presenter -> View
    func showNews(news:News)
}

protocol NewsPresenterProtocol: AnyObject {
    // View -> Presenter
    var view: NewsViewProtocol? { get set }
    var interactor: NewsInteractorProtocol? { get set }
    var router: NewsRouterProtocol? { get set }
    
    func showNews()
    func updateNews(news:News)
}

protocol NewsInteractorProtocol: AnyObject {
    // Presenter -> Interactor
    var presenter:NewsPresenterProtocol? {get set}
    func loadNews()
}

protocol NewsRouterProtocol: AnyObject {
    // Presenter -> Router
    static func createNewsView() -> NewsViewController
}
