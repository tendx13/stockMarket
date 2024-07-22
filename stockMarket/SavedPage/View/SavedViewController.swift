//
//  SavedViewController.swift
//  stockMarket
//
//  Created by Денис Кононов on 16.07.2024.
//

import UIKit
import SnapKit

class SavedViewController: UIViewController,SavedViewProtocol {
    
    private lazy var savedTableView:UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(MainTableViewCell.self, forCellReuseIdentifier: "saved")
        return table
    }()
    private lazy var titleLabel:UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Saved stocks"
        return label
    }()
    
    var presenter:SavedPresenterProtocol?
    var stocks:Stock = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.fetchStocks()
        print(stocks)

    }
    
    func showSavedStock(stock:Stock) {
      stocks = stock
        savedTableView.reloadData()
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        
        view.addSubview(titleLabel)
        view.addSubview(savedTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        savedTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}



extension SavedViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = savedTableView.dequeueReusableCell(withIdentifier: "saved", for: indexPath) as! MainTableViewCell
        let stock = stocks[indexPath.row]
        cell.config(stock: stock)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let stock = self.stocks[indexPath.row]
            let symbol = stock.symbol
            presenter?.interactor?.deleteStock(symbol: symbol)
            self.presenter?.fetchStocks()
            completionHandler(true)
        }
    
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "bin.xmark.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("123")
        let selectedSymbol = self.stocks[indexPath.row].symbol
        print(selectedSymbol)
        presenter?.showDetail(for: selectedSymbol)
    }
    
}
