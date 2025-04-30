//
//  CoinsPresenterTests.swift
//  CoinRankingTests
//
//  Created by Kelvin Ofula on 4/30/25.
//

import XCTest
@testable import CoinRanking

@MainActor
final class CoinsPresenterTests: XCTestCase {
    private var presenter: CoinsPresenter!
    private var mockService: MockCoinsListService!
    private var mockStore: MockFavouritesStore!
    private var mockView: MockCoinsView!

    override func setUp() {
        super.setUp()
        mockService = MockCoinsListService()
        mockStore = MockFavouritesStore()
        mockView = MockCoinsView()
        presenter = CoinsPresenter(view: mockView, service: mockService, store: mockStore)
    }

    override func tearDown() {
        presenter = nil
        mockService = nil
        mockStore = nil
        mockView = nil
        super.tearDown()
    }

    func testFetchCoinsSuccess() async {
        await presenter.fetchCoins()

        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertEqual(mockView.displayedCoins?.count, 2)
        XCTAssertEqual(mockService.fetchedPage, 1)
        XCTAssertEqual(mockService.fetchedSortOption, .marketCap)
        XCTAssertEqual(mockService.fetchedSortDirection, .descending)
    }

    func testFetchCoinsFailure() async {
        mockService.shouldReturnError = true
        await presenter.fetchCoins()

        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
        XCTAssertNotNil(mockView.displayedError)
    }

    func testLoadMoreIncrementsPage() async {
        await presenter.loadMore()

        XCTAssertEqual(mockService.fetchedPage, 2)
    }

    func testToggleFavourite() {
        let uuid = "1"

        presenter.toggleFavourite(for: uuid)
        XCTAssertTrue(mockStore.isFavorite(uuid))

        presenter.toggleFavourite(for: uuid)
        XCTAssertFalse(mockStore.isFavorite(uuid))
    }

    func testIsFavourite() {
        let uuid = "1"
        mockStore.addFavorite(uuid)

        XCTAssertTrue(presenter.isFavourite(uuid))
    }

    func testSortCoinsClearsDataAndFetches() async {
        await presenter.sortCoins(by: .price, direction: .ascending)

        XCTAssertEqual(mockService.fetchedSortOption, .price)
        XCTAssertEqual(mockService.fetchedSortDirection, .ascending)
        XCTAssertEqual(mockService.fetchedPage, 1)
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
    }
}

