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
        table.isScrollEnabled = false
        return table
    }()
    
    private lazy var seeMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("See More", for: .normal)
        button.addTarget(self, action: #selector(seeMore), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var newsScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
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
        view.addSubview(newsScrollView)
        newsScrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newsTableView)
        contentView.addSubview(seeMoreButton)
        
        newsScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(newsScrollView)
            make.width.equalTo(newsScrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
        
        newsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(0)
        }
        
        seeMoreButton.snp.makeConstraints { make in
            make.top.equalTo(newsTableView.snp.bottom).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    private func updateTableViewHeight() {
        newsTableView.snp.updateConstraints { make in
            make.height.equalTo(newsTableView.contentSize.height)
        }
    }
    
    // MARK: - NewsViewProtocol
    
    func showNews(news: News) {
        self.news = news.content
        newsTableView.reloadData()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc func seeMore() {
        guard let url = URL(string: "https://financialmodelingprep.com/market-news") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
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
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
