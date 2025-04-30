//
//  MockFavouritesStore.swift
//  CoinRankingTests
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation
@testable import CoinRanking

final class MockFavouritesStore: FavoritesStoreProtocol {
    
    private var favourites = Set<String>()

    func addFavorite(_ uuid: String) {
        favourites.insert(uuid)
    }

    func removeFavorite(_ uuid: String) {
        favourites.remove(uuid)
    }

    func isFavorite(_ uuid: String) -> Bool {
        return favourites.contains(uuid)
    }

    func allFavorites() -> [String] {
        return Array(favourites)
    }
    
    func toggleFavorite(_ uuid: String) -> Bool {
        if favourites.contains(uuid) {
            favourites.remove(uuid)
            return false
        } else {
            favourites.insert(uuid)
            return true
        }
    }
}
