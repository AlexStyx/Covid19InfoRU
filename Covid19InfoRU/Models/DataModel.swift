//
//  DataModel.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/28/21.
//

import Foundation

struct StatusDataModel: Codable {
    let confirmed, deaths, recovered: Int
    let date: String

    enum CodingKeys: String, CodingKey {
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case date = "Date"
    }
}

