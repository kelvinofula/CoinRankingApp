//
//  MainCoordinator.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SplashVC.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openDashboard() {
        let vc = DashboardVC()
        vc.coordinator = self
        vc.tabBarView.selectedIndex = 0
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openCoinDetails(coin: CoinModel) {
        let vc = CoinDetailsVC(coin: coin)
        navigationController.pushViewController(vc, animated: true)
    }
}
