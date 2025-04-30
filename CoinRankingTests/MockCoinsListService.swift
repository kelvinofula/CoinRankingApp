//
//  MockCoinsListService.swift
//  CoinRankingTests
//
//  Created by Kelvin Ofula on 4/30/25.
//

import XCTest
@testable import CoinRanking

final class MockCoinsListService: CoinsServiceProtocol {
    var shouldReturnError = false
    var fetchedPage: Int?
    var fetchedSortOption: SortOption?
    var fetchedSortDirection: SortDirection?
    var fetchedUuids: [String]?

    func fetchCoins(page: Int, sortOption: SortOption, sortDirection: SortDirection) async -> Result<CoinAPIResponse, Error> {
        fetchedPage = page
        fetchedSortOption = sortOption
        fetchedSortDirection = sortDirection

        if shouldReturnError {
            return .failure(NSError(domain: "TestError", code: 0, userInfo: nil))
        }

        let mockResponse = CoinAPIResponse(data: CoinAPIResponse.CoinData(coins: [
            CoinModel(uuid: "1", rank: 1, price: "98000", iconUrl: "", change: "6.4", symbol: "BTC", marketCap: "1T"),
            CoinModel(uuid: "2", rank: 2, price: "3000", iconUrl: "", change: "-3.2", symbol: "ETH", marketCap: "500B"),
        ]))
        return .success(mockResponse)
    }

    func fetchFavouriteCoins(uuids: [String], page: Int, sortOption: SortOption, sortDirection: SortDirection) async -> Result<CoinAPIResponse, Error> {
        fetchedUuids = uuids
        fetchedPage = page
        fetchedSortOption = sortOption
        fetchedSortDirection = sortDirection

        if shouldReturnError {
            return .failure(NSError(domain: "TestError", code: 0, userInfo: nil))
        }

        let mockResponse = CoinAPIResponse(data: CoinAPIResponse.CoinData(coins: [
            CoinModel(uuid: "1", rank: 1, price: "98000", iconUrl: "", change: "6.4", symbol: "BTC", marketCap: "1T"),
            CoinModel(uuid: "2", rank: 2, price: "3000", iconUrl: "", change: "-3.2", symbol: "ETH", marketCap: "500B"),
        ]))
        return .success(mockResponse)
    }
}
