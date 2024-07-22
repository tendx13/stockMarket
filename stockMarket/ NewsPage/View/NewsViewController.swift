//
//  NewsViewController.swift
//  stockMarket
//
//  Created by Денис Кононов on 13.07.2024.
//

import UIKit
import SnapKit
import SafariServices

// MARK: - NewsViewController

class NewsViewController: UIViewController, NewsViewProtocol {
    
    // MARK: - UI Components
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Business News"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var newsTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: "news")
        table.rowHeight = 150
        return table
    }()
    
    var news: [Content] = []
    var presenter: NewsPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.showNews()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        view.addSubview(titleLabel)
        view.addSubview(newsTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        newsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: - NewsViewProtocol
    
    func showNews(news: News) {
        self.news = news.content
        newsTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "news", for: indexPath) as! NewsTableViewCell
        let news = self.news[indexPath.row]
        cell.configure(news: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = self.news[indexPath.row]
        guard let url = URL(string: news.link) else { return }
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true)
    }
}
