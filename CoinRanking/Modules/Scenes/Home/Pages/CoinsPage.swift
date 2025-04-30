//
//  CoinsPage.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit
import SwiftUI
import Combine

class CoinsPage: UIViewController {
    
    // MARK: - Properties
    var coordinator: MainCoordinator?
    
    private let tableview = UITableView(frame: .zero, style: .plain)
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private var presenter: CoinsPresenter!
    private var coins: [CoinModel] = []
    private let sortOptionsViewModel = SortOptionsViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var isSetup = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        presenter = CoinsPresenter(view: self)

        setupNavigationBar()
        setupSubviews()

        Task {
            await presenter.fetchCoins()
        }
    }
    
}

// MARK: - Conformance to CoinsListView protocols
extension CoinsPage: CoinsListView {
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

private extension CoinsPage {
    func setupNavigationBar() {
//        navigationItem.title = "Coins List"
//        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupSubviews() {
        view.backgroundColor = BG_COLOR

        // NOTE: this can't be added as a header in the tableview because every reload of the tableview
        // would cause this to be reloaded, which will then trigger the `selectedOption` sink. And that
        // will lead to infinite API calls and table reloads
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

        // configure table view
        tableview.register(CoinRowCell.self, forCellReuseIdentifier: CoinRowCell.reuseIdentifier)
        tableview.backgroundColor = BG_COLOR
        tableview.dataSource = self
        tableview.delegate = self
        view.addSubview(tableview)
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BOTTOM_SAFEAREA_HEIGHT + 70, right: 0)

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

extension CoinsPage: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinRowCell.reuseIdentifier, for: indexPath) as? CoinRowCell else {
            return UITableViewCell()
        }

        let coin = coins[indexPath.row]
        cell.configure(with: coin, forRowAt: indexPath.row)

        // load more when the last row is loaded
        if indexPath.row == (coins.count - 1) {
            Task {
                await presenter.loadMore()
            }
        }

        return cell
    }
}

extension CoinsPage: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let coin = coins[indexPath.row]

        let action = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            guard let self = self else {
                completion(false)
                return
            }
            
            let uuid = self.coins[indexPath.row].uuid
            self.presenter.toggleFavourite(for: uuid)
            
            // Ensures the table reloads this row (or the whole table if needed)
            DispatchQueue.main.async {
                self.tableview.reloadRows(at: [indexPath], with: .automatic)
            }
            
            completion(true)
        }

        if presenter.isFavourite(coin.uuid) {
            action.backgroundColor = .systemRed
            action.image = UIImage(named: "remove_favourite")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        } else {
            action.backgroundColor = .systemGreen
            action.image = UIImage(named: "add_favourite")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        }

        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false

        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = coins[indexPath.row]
        coordinator?.openCoinDetails(coin: coin)
//        let controller = CoinDetailsVC(coin: coin)
//        navigationController?.pushViewController(controller, animated: true)
    }
}
