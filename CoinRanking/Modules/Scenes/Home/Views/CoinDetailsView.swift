//
//  CoinDetailsView.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import SwiftUI

struct CoinDetailsView: View {
    @StateObject var viewModel: CoinDetailsViewModel

    private var isPositiveChange: Bool {
        if let val = Double(viewModel.details?.change ?? ""), val > 0 {
            return true
        }
        return false
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Name, price, 24h change
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(viewModel.details?.name ?? "")
                                .font(.body)
                                .foregroundStyle(Color(PRIMARY_COLOR))

                            Text("#\(viewModel.details?.rank ?? 0)")
                                .font(.footnote)
                                .foregroundStyle(Color.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            Spacer()
                        }

                        Text("$\(viewModel.details?.price.formatPrice() ?? "")")
                            .font(.title)
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    Spacer()

                    Text("\(viewModel.details?.change ?? "")%")
                        .font(.title3)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(isPositiveChange ? Color.green : Color.red)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Divider()
                    .background(Color(GRAY_COLOR))

                // Chart
                if viewModel.isLoadingHistory {
                    ProgressView()
                        .padding()
                } else {
                    CoinHistView(history: viewModel.history)
                }

                Divider()
                    .background(Color(GRAY_COLOR))

                // Description
                Text(viewModel.details?.description ?? "")
                    .font(.subheadline)
                    .foregroundStyle(Color(PRIMARY_COLOR))

                Divider()
                    .background(Color(GRAY_COLOR))

                // Statistics
                if viewModel.isLoadingDetails {
                    ProgressView()
                        .padding()
                } else {
                    CoinStatsView(viewModel: viewModel)
                }
            }
        }
        .padding(.horizontal, 8)
        .background(Color(BG_COLOR))
        .foregroundStyle(Color(PRIMARY_COLOR))
        .task {
            await viewModel.fetchDetails()
            await viewModel.fetchHistory()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil }}
            ),
            presenting: viewModel.errorMessage) { _ in
                Button("Cancel", role: .cancel) {}
            } message: { message in
                Text(message)
            }
    }
}

#Preview {
    let coin = CoinModel(
        uuid: "idags",
        rank: 1,
        price: "98432.12",
        iconUrl: "https://cdn.coinranking.com/Sy33Krudb/btc.svg",
        change: "+1820.4",
        symbol: "BTC",
        marketCap: "1385434234543"
    )
    let viewModel = CoinDetailsViewModel(coin: coin)

    return CoinDetailsView(viewModel: viewModel)
}
