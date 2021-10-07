//
//  ViewController.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var chartViewViewModel = ChartViewViewModel()

    //MARK: - Creating Views
    private let chart = ChartView()
    private let infoView = InfoView()
    
    private let periodSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Week", "30 days", "All time"])
        segmentedControl.addTarget(self, action: #selector(periodSegmentedControlChangedValue), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let categorySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Confirmed", "Deaths", "Recovered"])
        segmentedControl.addTarget(self, action: #selector(categorySegmentedControlChangedValue), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    @objc private func periodSegmentedControlChangedValue(_ sender: UISegmentedControl) {
        let selectedPeriod = Period.allCases[sender.selectedSegmentIndex]
        chartViewViewModel.update(period: selectedPeriod)
    }
    
    @objc private func categorySegmentedControlChangedValue(_ sender: UISegmentedControl) {
        let selectedCategory = TypeOfChart.allCases[sender.selectedSegmentIndex]
        chartViewViewModel.update(category: selectedCategory)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkService = NetworkService()
        networkService.delegate = self
        networkService.performRequest()
        setupUI()
    }
    
    //MARK: - UI
    private func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        layout()
    }
    
    private func addSubviews() {
        view.addSubview(chart)
        view.addSubview(infoView)
        view.addSubview(periodSegmentedControl)
        view.addSubview(categorySegmentedControl)
    }
    
    private func layout() {
        periodSegmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        chart.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(periodSegmentedControl.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        categorySegmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(chart.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        infoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}

// MARK: - NetworkServiceDelegate
extension ViewController: NetworkServiceDelegate {
    func didUpdateStatistics(_ statistics: Statistics) {
        DispatchQueue.main.async { [self] in
            infoView.setup(statisctics: statistics)
            chart.setup(viewModel: chartViewViewModel)
            chartViewViewModel.setup(statisctics: statistics, period: Period.allCases[periodSegmentedControl.selectedSegmentIndex])
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async { [self] in
            chart.setup(viewModel: chartViewViewModel)
            chartViewViewModel.setup(statisctics: Statistics(allTimeStatistics: []), period: Period.allCases[periodSegmentedControl.selectedSegmentIndex])
        }
    }
}
