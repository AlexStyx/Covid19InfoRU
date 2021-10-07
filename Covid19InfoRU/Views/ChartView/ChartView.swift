//
//  ChartView.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit
import RxCocoa
import RxSwift

class ChartView: UIView {
    
    private var viewModel: ChartViewViewModelType? {
        didSet {
            setupObservation()
        }
    }
    
    private var numberOfPoints = 0
    private var maxYValue: CGFloat = 0
    private var xCoordinates: [CGFloat] = []
    private var yCoordinates: [CGFloat] = []
    private var points: [CGPoint] = []
    private var bag = DisposeBag()
    private var bubbleView = BubbleView()

    private let noDataAvailibleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data Availible"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.isHidden = false
        indicator.startAnimating()
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(viewModel: ChartViewViewModel?) {
        self.viewModel = viewModel
    }
    
    private func calculateNumberOfPoints(items: [Int]) {
        numberOfPoints = items.count
    }
    
    private func calculateMaxYValue(items: [Int]) {
        for value in items.last!...(items.last! + 5) {
            if value % 5 == 0 {
                maxYValue = CGFloat(value)
            }
        }
    }
    
    private func calculateCoordinates(items: [Int]) {
        xCoordinates = []
        yCoordinates = []
        let xValuePerPoint = bounds.width / CGFloat(numberOfPoints)
        let yValuePerPoint = (bounds.height - bubbleView.frame.height) / maxYValue
        for xValue in 0..<numberOfPoints {
            let xCoordinate = CGFloat(xValue) * xValuePerPoint
            xCoordinates.append(xCoordinate)
        }
        for yValue in items {
            let yCoordinate = bounds.height - bubbleView.frame.height -  CGFloat(yValue) * yValuePerPoint
            yCoordinates.append(yCoordinate)
        }
    }
    
    private func calculatePoints() {
        points = []
        var newPoints = [CGPoint]()
        for index in 0..<numberOfPoints {
            let xCoordinate = xCoordinates[index]
            let yCoordinate = yCoordinates[index]
            let point = CGPoint(x: xCoordinate, y: yCoordinate)
            newPoints.append(point)
        }
        self.points = newPoints
    }
    
    private func updateUI(with items: [Int]) {
        if !activityIndicator.isHidden {
            activityIndicator.stopAnimating()
        }
        for view in subviews {
            switch view {
            case view as BubbleView: break
            case view as UILabel: break
            default : view.removeFromSuperview()
            }
        }
        if items.count > 0 {
            noDataAvailibleLabel.isHidden = true
            backgroundColor = .white
            calculateNumberOfPoints(items: items)
            calculateMaxYValue(items: items)
            calculateCoordinates(items: items)
            calculatePoints()
        } else {
            noDataAvailibleLabel.isHidden = false
            points = []
            xCoordinates = []
            yCoordinates = []
            numberOfPoints = 0
            maxYValue = 0
        }
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        if viewModel != nil {
            guard let context = UIGraphicsGetCurrentContext() else { fatalError("Cannot get context") }
            drawChart(using: context, of: viewModel?.publishedCategory ?? .confirmed)
        }
    }
    
    private func drawChart(using context: CGContext, of type: TypeOfChart) {
        var lineColor: CGColor
        switch type {
        case .recovered: lineColor = UIColor.green.cgColor
        case .deaths: lineColor = UIColor.red.cgColor
        case .confirmed: lineColor = UIColor.blue.cgColor
        }
        if let start = points.first {
            context.move(to: start)
        }
        for point in points {
            context.addLine(to: point)
        }
        context.setLineWidth(2)
        context.setStrokeColor(lineColor)
        context.strokePath()
    }
    
    private func setupObservation() {
        viewModel?.items.subscribe({ event in
            switch event {
            case .next(let newItems):
                self.changeBubblePeriod(items: newItems)
                self.updateUI(with: newItems)
            case .error(let error): fatalError(error.localizedDescription)
            case .completed: break
            }
        }).disposed(by: bag)
    }
    
    private func changeBubblePeriod(items: [Int]) {
        switch items.count {
        case 7: bubbleView.period = .week
        case 30: bubbleView.period = .month
        case 31...: bubbleView.period = .allTime
        default: break
        }
    }
    
    private func setupUI() {
        addSubview(bubbleView)
        bubbleView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        addSubview(noDataAvailibleLabel)
        noDataAvailibleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noDataAvailibleLabel.snp.bottom).offset(5)
        }
    }
}
