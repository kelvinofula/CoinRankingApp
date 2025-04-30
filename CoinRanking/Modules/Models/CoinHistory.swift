//
//  CoinHistory.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation

struct CoinHistory: Decodable {
    let price: String
    let timestamp: TimeInterval
}

struct CoinHistoryAPIResponse: Decodable {
    struct History: Decodable {
        let history: [CoinHistory]
    }

    let data: History
}
