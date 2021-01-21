//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency(currency: CurrencyModel)
    
    func didFailWithError(error: Error)
}

struct CurrencyModel: Decodable {
    var asset_id_base: String
    var asset_id_quote: String
    var rate: Double
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=45F722AD-2218-46A2-992F-BCD57C1B7CE8"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                if let safeData = data {
                    if let currency = self.parseJSON(currencyData: safeData) {
                        self.delegate?.didUpdateCurrency(currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(currencyData: Data) -> CurrencyModel? {
          let decoder = JSONDecoder()
          do {
                let decoderData = try decoder.decode(CurrencyModel.self, from: currencyData)
                let currencyRate = CurrencyModel(asset_id_base: decoderData.asset_id_base, asset_id_quote: decoderData.asset_id_quote, rate: decoderData.rate)

                  return currencyRate
                  
              } catch {
                self.delegate?.didFailWithError(error: error)
                   return nil
          }
      }

}




