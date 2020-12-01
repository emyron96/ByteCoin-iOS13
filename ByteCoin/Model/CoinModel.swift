//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Myron Evans Jr. on 8/30/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let rate: Double
    let asset_id_quote: String
    
    var rateString: String {
        return String(format: "%.4f", rate)
    }
    
}
