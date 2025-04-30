//
//  CoinModel.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation

struct CoinModel: Decodable {
    let uuid: String
    let rank: Int
    let price: String
    let iconUrl: String
    let change: String
    let symbol: String
    let marketCap: String
}

struct CoinAPIResponse: Decodable {
    struct CoinData: Decodable {
        let coins: [CoinModel]
    }

    let data: CoinData
}
