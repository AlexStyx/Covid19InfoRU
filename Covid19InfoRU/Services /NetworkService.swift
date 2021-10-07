//
//  NetworkService.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/28/21.
//

import Foundation

protocol NetworkServiceDelegate {
    func didFailWithError(error: Error)
    func didUpdateStatistics(_ statistics: Statistics)
}

class NetworkService {
    
    var delegate: NetworkServiceDelegate?
    
    func performRequest() {
        guard let url = configureURL(params: params())  else { return }
        let session = URLSession.shared
        session.dataTask(with: url) {  data, response, error in
            guard
                let data = data,
                error == nil
            else {
                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                }
                fatalError("Unknown error")
            }
            guard let statistics = self.parseJSON(data: data) else { return }
            self.delegate?.didUpdateStatistics(statistics)
        }.resume()
    }
    
    private func params() -> [String: String] {
        let now = Date()
        let aYearAgo = now.aYearAgo()
        return ["from" : aYearAgo.toString(), "to" : now.toString()]
    }
    
    private func configureURL(params: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.covid19api.com"
        urlComponents.path = "/country/russia"
        urlComponents.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
        return urlComponents.url
    }
    
    private func parseJSON(data: Data) -> Statistics? {
        let decoder = JSONDecoder()
        do {
            let statuses = try decoder.decode([StatusDataModel].self, from: data).map {Status(confirmed: $0.confirmed, deaths: $0.deaths, recovered: $0.recovered, date: Date.fromString($0.date))}
            let statistics = Statistics(allTimeStatistics: statuses)
            return statistics
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
