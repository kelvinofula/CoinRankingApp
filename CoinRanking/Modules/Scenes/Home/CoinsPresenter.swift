//
//  CoinsPresenter.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation

protocol CoinsListView: AnyObject {
    func showLoading()
    func hideLoading()
    func display(_ coins: [CoinModel])
    func display(_ error: String)
}

@MainActor
final class CoinsPresenter {
    static let maximumCoins = 100

    private weak var view: CoinsListView?
    private let service: CoinsServiceProtocol
    private let store: FavoritesStoreProtocol

    private var coins = [CoinModel]()
    private var isLoading = false
    private var currentPage = 1
    private var selectedSortOption: SortOption = .marketCap
    private var sortDirection: SortDirection = .descending
    
    init(view: CoinsListView?, service: CoinsServiceProtocol = CoinsListService(), store: FavoritesStoreProtocol = FavoritesStore.shared) {
        self.view = view
        self.service = service
        self.store = store
    }
    
    func fetchCoins() async {
        guard !isLoading, coins.count < Self.maximumCoins else { return }
        isLoading = true
        view?.showLoading()

        let result = await service.fetchCoins(page: currentPage, sortOption: selectedSortOption, sortDirection: sortDirection)
        switch result {
        case .failure(let error):
            view?.display(error.localizedDescription)
        case .success(let response):
            coins.append(contentsOf: response.data.coins)
            view?.display(coins)
        }

        isLoading = false
        view?.hideLoading()
    }

    func loadMore() async {
        currentPage += 1
        await fetchCoins()
    }

    func toggleFavourite(for uuid: String) {
        if store.isFavorite(uuid) {
            store.removeFavorite(uuid)
        } else {
            store.addFavorite(uuid)
        }
    }

    func isFavourite(_ uuid: String) -> Bool {
        //return store.toggleFavorite(uuid)
        return store.isFavorite(uuid)
    }

    func sortCoins(by option: SortOption, direction: SortDirection) async {
        selectedSortOption = option
        sortDirection = direction
        coins = []
        currentPage = 1
        await fetchCoins()
    }
}
