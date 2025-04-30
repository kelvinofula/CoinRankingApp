//
//  CoinRowCell.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import Foundation
import SwiftUI

final class CoinRowCell: UITableViewCell {
    static let reuseIdentifier = "\(CoinRowCell.self)"
    private var hostingController: UIHostingController<CoinRowView>?

    func configure(with coin: CoinModel, forRowAt index: Int) {
        selectionStyle = .none
        
        let view = CoinRowView(position: index + 1, coin: coin)
        if let hostingController = hostingController {
            hostingController.view.removeFromSuperview()
        }

        let controller = UIHostingController(rootView: view)
        hostingController = controller
        contentView.addSubview(controller.view)

        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
