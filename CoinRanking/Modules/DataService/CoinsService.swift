//
//  CoinsService.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation

enum CoinsEndpoint: APIEndpoint {
    case getCoins(page: Int, sortOption: SortOption, sortDirection: SortDirection)
    case getFavourites(uuids: [String], page: Int, sortOption: SortOption, sortDirection: SortDirection)

    var path: String { return "/coins" }

    var parameters: [String : Any]? {
        let limit = 20

        switch self {
        case .getCoins(let page, let sortOption, let sortDirection):
            return [
                "offset": (page - 1) * limit,
                "limit": limit,
                "orderBy": sortOption.apiValue,
                "orderDirection": sortDirection.apiValue
            ]
        case .getFavourites(let uuids, let page, let sortOption, let sortDirection):
            return [
                "offset": (page - 1) * limit,
                "limit": limit,
                "uuids[]": uuids,
                "orderBy": sortOption.apiValue,
                "orderDirection": sortDirection.apiValue
            ]
        }
    }
}

protocol CoinsServiceProtocol: AnyObject {
    func fetchCoins(page: Int, sortOption: SortOption, sortDirection: SortDirection) async -> Result<CoinAPIResponse, Error>
    func fetchFavouriteCoins(uuids: [String], page: Int, sortOption: SortOption, sortDirection: SortDirection) async -> Result<CoinAPIResponse, Error>
}

final class CoinsListService: CoinsServiceProtocol {
    let apiClient: APIClient

    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchCoins(page: Int, sortOption: SortOption, sortDirection: SortDirection) async -> Result<CoinAPIResponse, Error> {
        let endpoint = CoinsEndpoint.getCoins(page: page, sortOption: sortOption, sortDirection: sortDirection)
        return await apiClient.request(endpoint)
    }

    func fetchFavouriteCoins(uuids: [String], page: Int, sortOption: SortOption, sortDirection: SortDirection) async -> Result<CoinAPIResponse, Error> {
        let endpoint = CoinsEndpoint.getFavourites(uuids: uuids, page: page, sortOption: sortOption, sortDirection: sortDirection)
        return await apiClient.request(endpoint)
    }
}
