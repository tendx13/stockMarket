//
//  MainTableViewCell.swift
//  stockMarket
//
//  Created by Денис Кононов on 03.07.2024.
//

import UIKit
import SkeletonView

// MARK: - MainTableViewCell

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var isShowingChangePercentage = false
    private var stock: StockElement?
    
    // MARK: - UI Elements
    
    private lazy var nameCompanyLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.alpha = 0.5
        return label
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var changesLabel: UILabel = {
        let label = UILabel()
        label.isSkeletonable = true
        label.textAlignment = .right
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChangesLabelTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
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
        contentView.addSubview(mainStackView)
        [nameStackView, priceStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        [symbolLabel, nameCompanyLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
        [priceLabel, changesLabel].forEach {
            priceStackView.addArrangedSubview($0)
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nameStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        symbolLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        symbolLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameCompanyLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameCompanyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        changesLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        changesLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: - Skeleton Animation Methods
    
    func startAnimateSkeleton() {
        nameCompanyLabel.showAnimatedGradientSkeleton()
        symbolLabel.showAnimatedGradientSkeleton()
        priceLabel.showAnimatedGradientSkeleton()
        changesLabel.showAnimatedGradientSkeleton()
    }
    
    func stopAnimatedSkeleton() {
        nameCompanyLabel.hideSkeleton()
        symbolLabel.hideSkeleton()
        priceLabel.hideSkeleton()
        changesLabel.hideSkeleton()
    }
    
    // MARK: - Configuration Method
    
    func config(stock: StockElement) {
        self.stock = stock
        nameCompanyLabel.text = stock.name
        symbolLabel.text = stock.symbol
        priceLabel.text = "\(stock.price)"
        updateChangesLabel(stock: stock)
        changesLabel.backgroundColor = stock.change > 0 ? UIColor.green.withAlphaComponent(0.7) : UIColor.red.withAlphaComponent(0.7)
    }
    
    // MARK: - Update Changes Label
        
        private func updateChangesLabel(stock: StockElement) {
            if isShowingChangePercentage {
                changesLabel.text = stock.changesPercentage > 0 ? "+\(String(format: "%.1f", stock.changesPercentage))%" : "\(String(format: "%.1f", stock.changesPercentage))%"
            } else {
                changesLabel.text = stock.change > 0 ? "+\(stock.change)" : "\(stock.change)"
            }
        }
        
        // MARK: - Handle Changes Label Tap
        
        @objc private func handleChangesLabelTap() {
            isShowingChangePercentage.toggle()
            updateChangesLabel(stock: stock! )
        }
}

