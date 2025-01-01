//
//  CoinView+.swift
//  CoinCraze
//
//  Created by Juan Carlos Gaytan Delgado on 2024-12-31.
//

import SwiftUI

struct CoinView: View {
    let coin: Coin
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [coin.color.opacity(0.8), coin.color]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 2)
            Circle()
                .strokeBorder(Color.black.opacity(0.6), lineWidth: 2)
            if isSelected {
                Circle()
                    .stroke(Color.yellow, lineWidth: 4)
            }
            Text("\(coin.value)")
                .foregroundColor(.white)
                .font(.headline)
                .bold()
        }
    }
}
