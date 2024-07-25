//
//  NewsInteractor.swift
//  stockMarket
//
//  Created by Денис Кононов on 13.07.2024.
//

import Foundation
import Alamofire

// MARK: - NewsInteractor

class NewsInteractor: NewsInteractorProtocol {
    
    // MARK: - Properties
    
    weak var presenter: NewsPresenterProtocol?
    
    private let apikey = "l66zrTGImfy8pVEuQVrNHc1dySLBamkH" //"RdWRaDUMdUkjzpiQC3byhmRFuzkrEmyf"
    private lazy var URLComponent: URLComponents = {
        var component = URLComponents(string: "https://financialmodelingprep.com")
        component?.queryItems = [
            URLQueryItem(name: "page", value: "0"),
            URLQueryItem(name: "size", value: "10"),
            URLQueryItem(name: "apikey", value: apikey)
        ]
        component?.path = "/api/v3/fmp/articles"
        return component ?? URLComponents()
    }()
    
    // MARK: - NewsInteractorProtocol
    
    func loadNews() {
        guard let url = URLComponent.url else { return }
        AF.request(url).responseDecodable(of: News.self) { response in
            guard let data = try? response.result.get() else { return }
            DispatchQueue.main.async {
                self.presenter?.updateNews(news: data)
            }
        }
    }
}
