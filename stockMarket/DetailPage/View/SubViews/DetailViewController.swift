//
//  DetailViewController.swift
//  stockMarket
//
//  Created by Денис Кононов on 14.07.2024.
//

import UIKit
import SnapKit
import DGCharts
import SafariServices

class DetailViewController: UIViewController, DetailViewProtocol {
    
    // MARK: - UI Components
    
    private lazy var symbol: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var beta: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var volAVG: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var mktCap: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var lastDiv: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var range: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var cik: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private lazy var changes: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var companyName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.alpha = 0.6
        return label
    }()
    
    private lazy var currency: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var website: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private lazy var descriptionCompany: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var companyNameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    
    private lazy var metricsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var detailScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    private lazy var lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.leftAxis.enabled = false
        chart.xAxis.labelPosition = .bottom
        return chart
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var timeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["All", "1D", "1W", "1M", "1Y"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(timeIntervalChanged), for: .valueChanged)
        return control
       }()
    
    // MARK: - Properties
    
    var presenter: DetailPresenterProtocol?
    var details: DetailElement?
    var historicalData: [ChartDataEntry] = [] {
        didSet {
            updateChart()
        }
    }
    var onDismiss: (() -> Void)?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.showDetail()
        presenter?.showHistoricalData(for: "All")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        onDismiss?()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        
        view.addSubview(detailScrollView)
        detailScrollView.addSubview(contentView)
        
        [companyNameStackView, website, currency, priceStackView, metricsStackView, lineChartView,timeSegmentedControl, descriptionCompany].forEach {
            contentView.addSubview($0)
        }
        
        [symbol, companyName].forEach { companyNameStackView.addArrangedSubview($0) }
        
        [price, changes].forEach { priceStackView.addArrangedSubview($0) }
        
        [leftStackView, rightStackView].forEach { metricsStackView.addArrangedSubview($0) }
        
        [volAVG, mktCap, range].forEach { rightStackView.addArrangedSubview($0) }
        
        [beta, lastDiv, cik].forEach { leftStackView.addArrangedSubview($0) }
        
        detailScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(detailScrollView)
            make.width.equalTo(detailScrollView)
        }
        
        companyNameStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
        
        website.snp.makeConstraints { make in
            make.top.equalTo(companyNameStackView.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
        }
        
        currency.snp.makeConstraints { make in
            make.top.equalTo(website.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(currency.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
        
        metricsStackView.snp.makeConstraints { make in
            make.top.equalTo(priceStackView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
        }
        
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(metricsStackView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.height.equalTo(300)
        }
        
        timeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(lineChartView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
        }
        
        descriptionCompany.snp.makeConstraints { make in
            make.top.equalTo(timeSegmentedControl.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(20)
        }
    }
    
    // MARK: - DetailViewProtocol
    
    func showDetail(detail: DetailElement) {
        details = detail
        content()
    }
    
    func showHistoricalData(data: [ChartDataEntry]) {
        historicalData = data
    }
    
    // MARK: - Updates UI
    
    func updateChart() {
        let dataSet = LineChartDataSet(entries: historicalData, label: "Price Changes")
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.setColor(.red)
        dataSet.fillColor = .red
        dataSet.fillAlpha = 0.3
        dataSet.drawFilledEnabled = true
        let data = LineChartData(dataSet: dataSet)
        data.setDrawValues(false)
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 2.5)
    }
    func content() {
        guard let details = details else { return }
        symbol.text = details.symbol ?? ""
        price.text = String(format: "%.2f", details.price ?? 0.0)
        beta.text = "beta: " + String(format: "%.2f", details.beta ?? 0.0)
        volAVG.text = "volAVG: \(details.volAvg ?? 0)"
        mktCap.text = "mktCap: \(details.mktCap ?? 0)"
        lastDiv.text = "lastDiv: " + String(format: "%.2f", details.lastDiv ?? 0.0)
        cik.text = "cik: \(details.cik ?? "")"
        range.text = "range: " + (details.range ?? "")
        changes.text = String(format: "%.2f", details.changes ?? 0.0)
        companyName.text = details.companyName ?? ""
        currency.text = details.currency ?? ""
        website.setTitle(details.website, for: .normal)
        descriptionCompany.text = details.description ?? ""
        if let changesValue = details.changes {
                if changesValue > 0 {
                    changes.text = String(format: "+%.2f", changesValue)
                    changes.textColor = .systemGreen
                } else if changesValue < 0 {
                    changes.text = String(format: "%.2f", changesValue)
                    changes.textColor = .systemRed
                } else {
                    changes.text = String(format: "%.2f", changesValue)
                    changes.textColor = .label
                }
            } else {
                changes.text = ""
            }
    }
    
    // MARK: - Actions

    @objc private func openLink(){
        guard let url = URL(string: website.title(for: .normal) ?? "") else {return}
        let safaryVC = SFSafariViewController(url: url)
        present(safaryVC, animated: true)
    }
    @objc private func timeIntervalChanged(_ sender: UISegmentedControl) {
        let periods = ["All", "1d", "1w", "1m", "1y"]
        let selectedPeriod = periods[sender.selectedSegmentIndex]
        presenter?.showHistoricalData(for: selectedPeriod)
    }
}
