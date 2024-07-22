//
//  NewsPresenter.swift
//  stockMarket
//
//  Created by Денис Кононов on 13.07.2024.
//

import Foundation

class NewsPresenter: NewsPresenterProtocol {
    
    weak var view: NewsViewProtocol?
    var interactor: NewsInteractorProtocol?
    var router: NewsRouterProtocol?
    
    func showNews() {
        interactor?.loadNews()
    }
    
    func updateNews(news: News) {
        view?.showNews(news: news)
    }
    
}
