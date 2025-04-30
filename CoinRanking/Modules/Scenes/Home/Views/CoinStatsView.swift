//
//  CoinStatsView.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import SwiftUI

struct CoinStatsView: View {
    @StateObject var viewModel: CoinDetailsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Statistics")
                .font(.title)
                .foregroundStyle(Color(PRIMARY_COLOR))

            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Market Cap")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("$\(viewModel.details?.marketCap.formatMarketCap() ?? "")")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Volume")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("$\(viewModel.details?.volume.formatMarketCap() ?? "")")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Max Supply")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("\(viewModel.details?.supply.max?.formatMarketCap() ?? "∞") \(viewModel.details?.symbol ?? "")")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("All Time High")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("$\(viewModel.details?.allTimeHigh.price.formatPrice() ?? "")")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Number of Markets")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("\(viewModel.details?.numberOfMarkets ?? 0)")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }
                }
                .font(.subheadline)

                Spacer()
                Divider()
                    .background(Color(GRAY_COLOR))
                    .padding(.trailing, 10)

                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Fully Diluted Market Cap")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text(viewModel.details?.fullyDilutedMarketCap.formatMarketCap() ?? "")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Circulating Supply")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("\(viewModel.details?.supply.circulating.formatMarketCap() ?? "") \(viewModel.details?.symbol ?? "")")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Total Supply")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("\(viewModel.details?.supply.total.formatMarketCap() ?? "") \(viewModel.details?.symbol ?? "")")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ranks")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("#\(viewModel.details?.rank ?? 0)")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Number of Exhanges")
                            .foregroundStyle(Color(PRIMARY_COLOR))
                        Text("\(viewModel.details?.numberOfExchanges ?? 0)")
                            .bold()
                            .foregroundStyle(Color(PRIMARY_COLOR))
                    }
                }
                .font(.subheadline)
            }
        }
        .background(Color(BG_COLOR))
        .foregroundStyle(Color(SECONDARY_COLOR))
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

    return CoinStatsView(viewModel: viewModel)
}
