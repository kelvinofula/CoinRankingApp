//
//  FavoritesPage.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit
import SwiftUI
import Combine

class FavoritesPage: UIViewController {
    
    // MARK: - Properties
    var coordinator: MainCoordinator?
    
    private let tableview = UITableView(frame: .zero, style: .plain)
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    private var presenter: FavoriteCoinsPresenter!
    private var coins: [CoinModel] = []
    private let sortOptionsViewModel = SortOptionsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var isSetup = true

    // MARK: - Init
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Task {
            await presenter.viewDidAppear()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupSubviews()

        presenter = FavoriteCoinsPresenter(view: self)
    }
    
}

private extension FavoritesPage {
    func setupNavigationBar() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupSubviews() {
        view.backgroundColor = BG_COLOR

        // setup header
        let header = CoinsHeaderView(viewModel: self.sortOptionsViewModel)

        sortOptionsViewModel.$selectedOption.sink { [weak self] option in
            guard let self = self else { return }
            self.sortOptionWasSelected(option)
        }.store(in: &cancellables)

        let hostingController = UIHostingController(rootView: header)
        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hostingController.view.heightAnchor.constraint(equalToConstant: 40),
        ])
        hostingController.didMove(toParent: self)

        // setup table view
        tableview.register(CoinRowCell.self, forCellReuseIdentifier: CoinRowCell.reuseIdentifier)
        tableview.backgroundColor = BG_COLOR
        tableview.dataSource = self
        tableview.delegate = self
        view.addSubview(tableview)

        tableview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func sortOptionWasSelected(_ option: SortOption) {
        // Initially adding the sink to the sort view model seems to trigger a call. This might be because
        // the `selectedOption` in the view model has a default value. Either way, we don't want to do anything
        // during the initial setup. So exit if that is the case
        if isSetup {
            isSetup = false
            return
        }

        Task {
            await presenter.sortCoins(by: option, direction: sortOptionsViewModel.sortDirection)
        }
    }
}

extension FavoritesPage: CoinsListView {
    func showLoading() {
        tableview.tableFooterView = loadingIndicator
    }

    func hideLoading() {
        tableview.tableFooterView = UIView()
    }

    func display(_ coins: [CoinModel]) {
        self.coins = coins
        tableview.reloadData()
    }

    func display(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension FavoritesPage: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinRowCell.reuseIdentifier, for: indexPath) as? CoinRowCell else {
            return UITableViewCell()
        }

        let coin = coins[indexPath.row]
        cell.configure(with: coin, forRowAt: indexPath.row)

        if indexPath.row == (coins.count - 1) {
            Task {
                await presenter.loadMore()
            }
        }

        return cell
    }
}

extension FavoritesPage: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = coins[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completionHandler in
            self?.presenter.removeFavorite(coin.uuid)
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        action.image = UIImage(named: "remove_favourite")?.withTintColor(.white, renderingMode: .alwaysTemplate)

        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = coins[indexPath.row]
        let controller = CoinDetailsVC(coin: coin)
        navigationController?.pushViewController(controller, animated: true)
    }
}

