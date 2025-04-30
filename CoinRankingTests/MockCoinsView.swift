//
//  MockCoinsView.swift
//  CoinRankingTests
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation
@testable import CoinRanking

final class MockCoinsView: CoinsListView {
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayedCoins: [CoinModel]?
    var displayedError: String?

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func display(_ coins: [CoinModel]) {
        displayedCoins = coins
    }

    func display(_ error: String) {
        displayedError = error
    }
}
