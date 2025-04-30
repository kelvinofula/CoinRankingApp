//
//  CoinRowView.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import SwiftUI

struct CoinRowView: View {
    enum Dimensions {
        static let rank: CGFloat = 30
        static let price: CGFloat = 100
        static let icon: CGFloat = 40
        static let padding: CGFloat = 10
        static let change: CGFloat = 60
    }

    @State var position: Int
    @State var coin: CoinModel

    var body: some View {
        HStack {
            Text("\(position)")
                .foregroundColor(Color(PRIMARY_COLOR))
                .frame(width: Dimensions.rank, alignment: .leading)
                .foregroundStyle(Color(PRIMARY_COLOR))

            AsyncImage(url: URL(string: coin.iconUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: Dimensions.icon, height: Dimensions.icon)
                        .foregroundStyle(Color.black)
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: Dimensions.icon, height: Dimensions.icon)
                        .clipShape(Circle())
                case .failure:
                    Image("cryptocurrencycoin")
                        .resizable()
                        .frame(width: Dimensions.icon, height: Dimensions.icon)
                        .clipShape(Circle())
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .leading) {
                Text(coin.symbol)
                    .font(.body)
                    .bold()
                    .foregroundStyle(Color(PRIMARY_COLOR))

                Text(coin.marketCap.formatMarketCap())
                    .font(.caption)
                    .foregroundStyle(Color(SECONDARY_COLOR))
            }

            Spacer()

            Text("$\(coin.price.formatPrice())")
                .frame(width: Dimensions.price, alignment: .trailing)
                .foregroundStyle(Color(SECONDARY_COLOR))

            Text("\(coin.change)%")
                .foregroundStyle(Color(SECONDARY_COLOR))
                .frame(width: Dimensions.change)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.leading, Dimensions.padding)
        }
        .padding(.horizontal, Dimensions.padding)
        .padding(.vertical, 8)
        .background(Color(BG_COLOR))
    }
}

#Preview {
    let coin = CoinModel(
        uuid: "idone",
        rank: 1,
        price: "98432.12",
        iconUrl: "https://cdn.coinranking.com/Sy33Krudb/btc.svg",
        change: "+1820.4",
        symbol: "BTC",
        marketCap: "1385434234543")
    return CoinRowView(position: 1, coin: coin)
}
