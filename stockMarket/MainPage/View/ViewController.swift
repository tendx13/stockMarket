//
//  ViewController.swift
//  stockMarket
//
//  Created by Денис Кононов on 03.07.2024.
//

import UIKit
import SnapKit
import SkeletonView

// MARK: - ViewController

class ViewController: UIViewController, MainViewProtocol {
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Stock Market"
        return label
    }()
   
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.alpha = 0.6
        label.text = presenter?.getCurrentDate(locale: Locale(identifier: "en_Us"))
        return label
    }()
    
    private lazy var stockTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "main")
        table.isSkeletonable = true
        return table
    }()
    
    private lazy var mainSearchBar: UISearchBar = {
        let search = UISearchBar()
        let image = UIImage()
        search.delegate = self
        search.setBackgroundImage(image, for: .any, barMetrics: .default)
        search.placeholder = "Search"
        return search
    }()
    
    private lazy var savedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Saved", for: .normal)
        button.addTarget(self, action: #selector(savedButtonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    // MARK: - Properties
    
    var stocks: Stock = []
    var filteredStocks: Stock = []
    var presenter: MainPresenterProtocol?

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        MainRouter.createStockView(viewController: self)
        setupUI()
        presenter?.showStock()
        presenter?.router?.navigateToNews()
    }
    
    // MARK: - Setup UI

    private func setupUI() {
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        [titleLabel, dateLabel, mainSearchBar, savedButton, stockTableView].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        mainSearchBar.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        savedButton.snp.makeConstraints { make in
            make.top.equalTo(mainSearchBar.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        stockTableView.snp.makeConstraints { make in
            make.top.equalTo(savedButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // MARK: - MainViewProtocol Methods

    func showStock(stock: Stock) {
        DispatchQueue.main.async {
            self.stocks = stock
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.stockTableView.reloadData()
            }
        }
        self.filteredStocks = stock
        stockTableView.reloadData()
    }
    
    // MARK: - Actions

    @objc func savedButtonTapped() {
        presenter?.router?.navigateToSaved()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredStocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = stockTableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! MainTableViewCell
        if stocks.isEmpty {
            cell.startAnimateSkeleton()
        } else {
            cell.stopAnimatedSkeleton()
        }
        let stock = filteredStocks[indexPath.row]
        cell.config(stock: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStockSymbol = filteredStocks[indexPath.row].symbol
        presenter?.router?.navigateToDetail(with: selectedStockSymbol)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveAction = UIContextualAction(style: .normal, title: "Save") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let stock = self.filteredStocks[indexPath.row]
            
            self.presenter?.interactor?.saveStock(stock: stock)
            self.stockTableView.reloadData()
            completionHandler(true)
        }
    
        saveAction.backgroundColor = .systemGreen
        saveAction.image = UIImage(systemName: "square.and.arrow.down")
        return UISwipeActionsConfiguration(actions: [saveAction])
    }
}

// MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text?.uppercased() else { return }
        if query.isEmpty {
            filteredStocks = stocks
        } else {
            print(query)
            filteredStocks = stocks.filter { $0.symbol.contains(query) }
            print(filteredStocks)
        }
                
        self.stockTableView.reloadData()
    }
}
