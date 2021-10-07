//
//  InfoView.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit

protocol InfoViewDelegate {
    func update()
}

class InfoView: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup(statisctics: Statistics) {
        for infoLabel in mainStackView.subviews {
            switch infoLabel {
            case let infoLabel as ConfirmedLabel: infoLabel.update(value: statisctics.confirmed)
            case let infoLabel as DeathsLabel: infoLabel.update(value: statisctics.deaths)
            case let infoLabel as RecoveredLabel: infoLabel.update(value: statisctics.recovered)
            default: break
            }
        }
    }
    
    private func setupUI() {
        addSubviews()
        layout()
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
    }
    
    private func layout() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [AboutLabel(), ConfirmedLabel(), DeathsLabel(), RecoveredLabel()])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
}
