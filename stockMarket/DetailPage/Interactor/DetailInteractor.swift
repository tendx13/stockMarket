//
//  DetailInteractor.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import Foundation
import Alamofire
import DGCharts

class DetailInteractor: DetailInteractorProtocol {
    
    // MARK: - Properties
    
    var stockSymbol: String
    weak var presenter: DetailPresenterProtocol?
    
    private let apikey =  APIConfig.shared.apiKey
    private lazy var baseComponent: URLComponents = {
        var component = URLComponents(string: "https://financialmodelingprep.com")
        component?.queryItems = [URLQueryItem(name: "apikey", value: apikey)]
        return component ?? URLComponents()
    }()
    
    // MARK: - Methods
    
    func loadDetail() {
        var component = baseComponent
        component.path = "/api/v3/profile/\(stockSymbol)"
        guard let url = component.url else { return }
        AF.request(url).responseDecodable(of: Detail.self) { response in
            switch response.result {
            case .success(let data):
                guard let detailElement = data.first else {
                    print("No data received or data array is empty")
                    return
                }
                DispatchQueue.main.async {
                    self.presenter?.updateDetail(detail: detailElement)
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    func loadHistoricalData(for period: String) {
        var component = baseComponent
        component.path = "/api/v3/historical-price-full/\(stockSymbol)"
        let fromDate = startDate(for: period)
        component.queryItems?.append(URLQueryItem(name: "from", value: fromDate))
        guard let url = component.url else { return }
        AF.request(url).responseDecodable(of: HistoricalData.self) { response in
            switch response.result {
            case .success(let data):
                let entries = data.historical.enumerated().compactMap { index, historical -> ChartDataEntry? in
                    guard let price = historical.historicalOpen else { return nil }
                    return ChartDataEntry(x: Double(index), y: price)
                }
                DispatchQueue.main.async {
                    self.presenter?.updateHistoricalData(data: entries)
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    func startDate(for interval: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let calendar = Calendar.current
        
        switch interval {
        case "All":
            guard let fiveYearAgo = calendar.date(byAdding: .year, value: -5, to: today) else { return "" }
            return dateFormatter.string(from: fiveYearAgo)
        case "1w":
            guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) else { return "" }
            return dateFormatter.string(from: weekAgo)
        case "1m":
            guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: today) else { return "" }
            return dateFormatter.string(from: monthAgo)
        case "1y":
            guard let yearAgo = calendar.date(byAdding: .year, value: -1, to: today) else { return "" }
            return dateFormatter.string(from: yearAgo)
        default:
            return dateFormatter.string(from: today)
        }
    }
    
    // MARK: - Initializer
    
    init(stockSymbol: String) {
        self.stockSymbol = stockSymbol
    }
}
