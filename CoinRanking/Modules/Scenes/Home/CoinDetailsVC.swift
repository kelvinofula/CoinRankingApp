//
//  CoinDetailsVC.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit
import SwiftUI

class CoinDetailsVC: UIViewController {

    private var coin: CoinModel
    private let viewModel: CoinDetailsViewModel

    init(coin: CoinModel) {
        self.coin = coin
        viewModel = CoinDetailsViewModel(coin: coin)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}

private extension CoinDetailsVC {
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = coin.symbol
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupSubviews() {
        view.backgroundColor = BG_COLOR

        let detailsView = CoinDetailsView(viewModel: self.viewModel)
        let hostingController = UIHostingController(rootView: detailsView)
        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}
