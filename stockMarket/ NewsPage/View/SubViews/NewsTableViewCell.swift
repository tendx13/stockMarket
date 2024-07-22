//
//  NewsTableViewCell.swift
//  stockMarket
//
//  Created by Денис Кононов on 13.07.2024.
//

import UIKit
import SnapKit

// MARK: - NewsTableViewCell

class NewsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var content: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.alpha = 0.8
        return label
    }()
    
    private lazy var date: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var author: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let dateAndAuthorStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        contentView.addSubview(title)
        contentView.addSubview(content)
        contentView.addSubview(dateAndAuthorStackView)
        dateAndAuthorStackView.addArrangedSubview(date)
        dateAndAuthorStackView.addArrangedSubview(author)
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(10)
        }
        content.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(10)
        }
        dateAndAuthorStackView.snp.makeConstraints { make in
            make.top.equalTo(content.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Configuration
    
    func configure(news: Content) {
        title.text = news.title
        content.text = news.content
        date.text = news.date
        author.text = news.author
    }
}
