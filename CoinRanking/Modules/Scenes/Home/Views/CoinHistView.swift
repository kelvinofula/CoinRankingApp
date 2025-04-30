//
//  CoinHistView.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import SwiftUI
import Charts

struct CoinHistView: View {
    let history: [CoinHistory]

    var body: some View {
        Chart(history, id: \.timestamp) { entry in
            LineMark(
                x: .value("Time", formattedTime(from: entry.timestamp)),
                y: .value("Price", Double(entry.price) ?? 0.0)
            )
            .foregroundStyle(Color.green)
        }
        .chartYScale(domain: priceRange())
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                    .foregroundStyle(Color(PRIMARY_COLOR))
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing) { value in
                AxisValueLabel()
                    .foregroundStyle(Color(PRIMARY_COLOR))
                AxisGridLine()
                    .foregroundStyle(Color(PRIMARY_COLOR))
                AxisTick()
            }

            // Add lowest and highest price markers
            if let prices = extremePrices() {
                AxisMarks(values: [prices.min, prices.max]) { value in
                    AxisValueLabel()
                        .font(.caption)
                        .foregroundStyle(Color(PRIMARY_COLOR))
                    AxisGridLine()
                        .foregroundStyle(Color(PRIMARY_COLOR))
                }
            }
        }
        .frame(height: 200)
        .background(Color(BG_COLOR))
    }

    private func formattedTime(from timestamp: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }

    private func amPMTime(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: date)
    }

    private func priceRange() -> ClosedRange<Double> {
        let prices = history.compactMap { Double($0.price) }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return 0...1
        }
        return minPrice...maxPrice
    }

    private func isExtremePrice(_ price: Double) -> Bool {
        let prices = history.compactMap { Double($0.price) }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return false
        }
        return price == minPrice || price == maxPrice
    }

    private func extremePrices() -> (min: Double, max: Double)? {
        let prices = history.compactMap { Double($0.price) }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else {
            return nil
        }
        return (min: minPrice, max: maxPrice)
    }
}

#Preview {
    let history = [
        CoinHistory(price: "91641.73371438966", timestamp: TimeInterval(1736774700)),
        CoinHistory(price: "91579.73371438966", timestamp: TimeInterval(1736774400)),
        CoinHistory(price: "91351.73371438966", timestamp: TimeInterval(1736774100)),
        CoinHistory(price: "91201.73371438966", timestamp: TimeInterval(1736773800)),
        CoinHistory(price: "90813.73371438966", timestamp: TimeInterval(1736773500)),
        CoinHistory(price: "90782.73371438966", timestamp: TimeInterval(1736773200)),
        CoinHistory(price: "90821.73371438966", timestamp: TimeInterval(1736772900)),
        CoinHistory(price: "90613.73371438966", timestamp: TimeInterval(1736772600)),
    ]

    return CoinHistView(history: history)
}
