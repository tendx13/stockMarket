//
//  MainInteractor.swift
//  stockMarket
//
//  Created by Денис Кононов on 03.07.2024.
//

import Foundation
import Alamofire

// MARK: - MainInteractorProtocol

final class MainInteractor: MainInteractorProtocol {
    
    // MARK: - Properties
    
    weak var presenter: MainPresenterProtocol?
    
    private let apikey = "l66zrTGImfy8pVEuQVrNHc1dySLBamkH" //"RdWRaDUMdUkjzpiQC3byhmRFuzkrEmyf"
    
    private lazy var baseComponent: URLComponents = {
        var component = URLComponents(string: "https://financialmodelingprep.com")
        component?.queryItems = [URLQueryItem(name: "apikey", value: apikey)]
        return component ?? URLComponents()
    }()
    
    // MARK: - Methods
    
    func loadStock() {
        var component = baseComponent
        component.path = "/api/v3/stock_market/actives"
        guard let url = component.url else { return }
        
        AF.request(url).responseDecodable(of: Stock.self) { response in
            guard let data = try? response.result.get() else { return }
            DispatchQueue.main.async {
                self.presenter?.updateStock(stock: data)
            }
        }
    }
       
    func getCurrentDate(locale: Locale) -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "dd MMMM"
        return dateFormatter.string(from: today)
    }
    
    func saveStock(stock: StockElement) {
        let coreDataStack = CoreDataStack.shared
        if coreDataStack.fetchStockBySymbol(stock.symbol) == nil {
            coreDataStack.saveStockToCoreData(stock)
        }
    }
}
