//
//  FavoriteCoinsPresenterTests.swift
//  CoinRankingTests
//
//  Created by Kelvin Ofula on 4/30/25.
//

import XCTest
@testable import CoinRanking

@MainActor
final class FavoriteCoinsPresenterTests: XCTestCase {
    private var presenter: FavoriteCoinsPresenter!
    private var mockService: MockCoinsListService!
    private var mockStore: MockFavouritesStore!
    private var mockView: MockCoinsView!

    override func setUp() {
        super.setUp()
        mockService = MockCoinsListService()
        mockStore = MockFavouritesStore()
        mockView = MockCoinsView()
        presenter = FavoriteCoinsPresenter(view: mockView, service: mockService, store: mockStore)
    }

    override func tearDown() {
        presenter = nil
        mockService = nil
        mockStore = nil
        mockView = nil
        super.tearDown()
    }

    func testViewDidAppearResetsStateAndFetchesFavourites() async {
        mockStore.addFavorite("1")
        mockStore.addFavorite("2")

        await presenter.viewDidAppear()

        XCTAssertEqual(mockService.fetchedUuids, ["1", "2"])
        XCTAssertEqual(mockService.fetchedPage, 1)
        XCTAssertEqual(mockService.fetchedSortOption, .marketCap)
        XCTAssertEqual(mockService.fetchedSortDirection, .descending)
        XCTAssertEqual(mockView.displayedCoins?.count, 2)
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func testLoadMoreIncrementsPageAndFetchesMoreFavourites() async {
        mockStore.addFavorite("1")
        mockStore.addFavorite("2")
        await presenter.loadMore()

        XCTAssertEqual(mockService.fetchedPage, 2)
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func testRemoveFavouriteUpdatesStoreAndView() async {
        mockStore.addFavorite("1")
        mockStore.addFavorite("2")
        await presenter.viewDidAppear()

        presenter.removeFavorite("1")

        XCTAssertFalse(mockStore.isFavorite("1"))
        XCTAssertEqual(mockStore.allFavorites().count, 1)
        XCTAssertEqual(mockView.displayedCoins?.count, 1)
        XCTAssertEqual(mockView.displayedCoins?.first?.uuid, "2")
    }

    func testSortCoinsClearsDataAndFetchesFavourites() async {
        mockStore.addFavorite("1")
        mockStore.addFavorite("2")

        await presenter.sortCoins(by: .price, direction: .ascending)

        XCTAssertEqual(mockService.fetchedSortOption, .price)
        XCTAssertEqual(mockService.fetchedSortDirection, .ascending)
        XCTAssertEqual(mockService.fetchedPage, 1)
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
    }

    func testFetchFavouritesHandlesEmptyFavourites() async {
        await presenter.viewDidAppear()

        XCTAssertNil(mockView.displayedCoins)
        XCTAssertFalse(mockView.showLoadingCalled) // No loading should occur
    }

    func testFetchFavouritesHandlesServiceFailure() async {
        mockStore.addFavorite("1")
        mockService.shouldReturnError = true

        await presenter.viewDidAppear()

        XCTAssertNotNil(mockView.displayedError)
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertTrue(mockView.hideLoadingCalled)
    }
}


