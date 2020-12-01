//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
 
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=70D87928-1AEF-4E68-8555-E97E96E83FA5"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func fetchCurrency(get currency: String){
        
        let urlString = "\(baseURL)/\(currency)\(apiKey)"
        performRequest(with: urlString)
    }
    
    func getCoinPrice(for currency: String){
        currency
    }
    
    func performRequest(with urlString: String){
        //create URL
        
        if let url = URL(string: urlString){
            //create a URLSession
            let session = URLSession(configuration: .default)
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                    
                }
            }
            //start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let id = decodedData.asset_id_quote
            let coin = CoinModel(rate: rate, asset_id_quote: id)
            return coin
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
}
