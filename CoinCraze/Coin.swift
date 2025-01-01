//
//  Coin.swift
//  CoinCraze
//
//  Created by Juan Carlos Gaytan Delgado on 2024-12-31.
//
import SwiftUI

struct Coin {
    let value: Int

    var color: Color {
        switch value {
        case 1: return .gray
        case 5: return .red
        case 10: return .green
        case 50: return .blue
        case 100: return .purple
        case 500: return .orange
        default: return .black
        }
    }
}
