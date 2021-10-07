//
//  ConfirmedLabel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/26/21.
//

import UIKit

class ConfirmedLabel: InfoLabel {
    
    override var categoryName: String { "Confirmed" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "Confirmed: 0"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
