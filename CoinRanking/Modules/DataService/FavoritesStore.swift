//
//  FavoritesStore.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation

protocol FavoritesStoreProtocol: AnyObject {
    func addFavorite(_ uuid: String)
    func removeFavorite(_ uuid: String)
    func isFavorite(_ uuid: String) -> Bool
    func allFavorites() -> [String]
    func toggleFavorite(_ uuid: String) -> Bool
}

final class FavoritesStore: FavoritesStoreProtocol {
    static let shared = FavoritesStore()
    private init() {}

    private var favorites = Set<String>()

    func addFavorite(_ uuid: String) {
        favorites.insert(uuid)
    }

    func removeFavorite(_ uuid: String) {
        favorites.remove(uuid)
    }

    func isFavorite(_ uuid: String) -> Bool {
        return favorites.contains(uuid)
    }

    func allFavorites() -> [String] {
        return Array(favorites)
    }
    
    func toggleFavorite(_ uuid: String) -> Bool {
        if favorites.contains(uuid) {
            favorites.remove(uuid)
            return false
        } else {
            favorites.insert(uuid)
            return true
        }
    }
}
