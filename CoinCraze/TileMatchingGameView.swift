//
//  TileMatchingGameView.swift
//  CoinCraze
//
//  Created by Juan Carlos Gaytan Delgado on 2024-12-31.
//

import SwiftUI
import AudioToolbox

struct TileMatchingGameView: View {
    @State private var grid: [[Coin]] = generateGrid(rows: 6, columns: 6)
    @State private var previewCoins: [Coin] = generatePreviewCoins(count: 6) // New preview line
    @State private var score: Int = 0
    @State private var selectedCoins: [(row: Int, column: Int)] = []
    @State private var level: Int = 1
    @State private var targetScore: Int = 5000
    @State private var showLevelUpAnimation = false

    var body: some View {
        ZStack {
            // Background Gradient for the Entire App
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                // Level, Target, and Score
                VStack(spacing: 4) {
                    Text("Level: \(level)")
                        .font(.headline)

                    Text("Target: \(targetScore)")
                        .font(.subheadline)

                    Text("Score: \(score)")
                        .font(.title)
                        .padding(.top, 4)
                }
                .padding(.horizontal)

                // Preview Line of Coins
                LazyHGrid(rows: [GridItem(.fixed(50))], spacing: 8) {
                    ForEach(previewCoins.indices, id: \.self) { index in
                        CoinView(coin: previewCoins[index], isSelected: false)
                            .frame(width: 50, height: 50)
                    }
                }
                .padding(.horizontal)

                // Grid of Coins
                GeometryReader { geometry in
                    let columns = 6
                    let spacing: CGFloat = 8
                    let totalSpacing = spacing * CGFloat(columns - 1)
                    let availableWidth = geometry.size.width - totalSpacing
                    let cellSize = availableWidth / CGFloat(columns)

                    LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: columns), spacing: spacing) {
                        ForEach(0..<grid.count, id: \.self) { row in
                            ForEach(0..<grid[row].count, id: \.self) { column in
                                if grid[row][column].value > 0 {
                                    CoinView(
                                        coin: grid[row][column],
                                        isSelected: selectedCoins.contains(where: { $0.row == row && $0.column == column })
                                    )
                                    .frame(width: cellSize, height: cellSize)
                                    .transition(.scale.combined(with: .opacity))
                                } else {
                                    Color.clear
                                        .frame(width: cellSize, height: cellSize)
                                }
                            }
                        }
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                self.handleDrag(at: value.location, cellSize: cellSize, spacing: spacing)
                            }
                            .onEnded { _ in
                                self.completeSelection()
                            }
                    )
                }
                .padding(.horizontal)

                // Reset Game Button
                VStack {
                    Button("Reset Game") {
                        self.resetGame()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            // Level-Up Animation Overlay
            if showLevelUpAnimation {
                Text("Level Up!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.yellow)
                    .shadow(color: .black, radius: 2)
                    .transition(.scale)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                self.showLevelUpAnimation = false
                            }
                        }
                    }
            }
        }
    }

    func handleDrag(at location: CGPoint, cellSize: CGFloat, spacing: CGFloat) {
        let column = Int(location.x / (cellSize + spacing))
        let row = Int(location.y / (cellSize + spacing))

        guard row >= 0, row < grid.count, column >= 0, column < grid[row].count else {
            return
        }

        let coin = grid[row][column]

        if selectedCoins.isEmpty {
            selectedCoins.append((row, column))
        } else if let lastSelected = selectedCoins.last {
            let isAdjacent = abs(lastSelected.row - row) <= 1 && abs(lastSelected.column - column) <= 1
            let isSameValue = coin.value == grid[lastSelected.row][lastSelected.column].value
            let isNotAlreadySelected = !selectedCoins.contains(where: { $0.row == row && $0.column == column })

            if isAdjacent && isSameValue && isNotAlreadySelected {
                selectedCoins.append((row, column))
            }
        }
    }

    func completeSelection() {
        guard let firstSelected = selectedCoins.first else { return }
        let coinValue = grid[firstSelected.row][firstSelected.column].value
        let sumOfCoins = selectedCoins.reduce(0) { $0 + grid[$1.row][$1.column].value }
        let nextValue = nextCoinValue(for: coinValue)

        if sumOfCoins >= nextValue {
            playSystemSound(success: true)
            withAnimation {
                for (row, column) in selectedCoins {
                    grid[row][column] = Coin(value: 0)
                }
                if nextValue != 1000 {
                    let firstSelected = selectedCoins[0]
                    grid[firstSelected.row][firstSelected.column] = Coin(value: nextValue)
                }
            }
            score += sumOfCoins
            if score >= targetScore {
                levelUp()
            }
        } else {
            playSystemSound(success: false)
        }

        selectedCoins.removeAll()
        shiftCoinsDown()
    }

    func shiftCoinsDown() {
        withAnimation {
            var newPreviewCoins = previewCoins // Temporary list to track updates

            for column in 0..<grid[0].count {
                var newColumn: [Coin] = []

                // Collect non-zero coins and track dropped positions
                for row in 0..<grid.count {
                    if grid[row][column].value != 0 {
                        newColumn.append(grid[row][column])
                    } else {
                        // Take the first available coin from the preview list
                        if !newPreviewCoins.isEmpty {
                            let droppedCoin = newPreviewCoins[column]
                            newColumn.insert(droppedCoin, at: 0)
                            newPreviewCoins[column] = generateCoin() // Generate new preview coin
                        }
                    }
                }

                // Update the grid with the new column
                for row in 0..<grid.count {
                    grid[row][column] = newColumn[row]
                }
            }

            // Persist the updated preview coins
            previewCoins = newPreviewCoins
        }
    }

    func levelUp() {
        level += 1
        targetScore += 5000
        score = 0
        selectedCoins.removeAll()

        // Generate a completely new grid and preview coins
        grid = generateGrid(rows: 6, columns: 6)
        previewCoins = generatePreviewCoins(count: 6) // Reset preview line

        // Validate if there are any valid moves, otherwise reshuffle
        while !isPlayable(grid: grid) {
            grid = generateGrid(rows: 6, columns: 6)
        }

        playLevelUpSound()

        withAnimation {
            showLevelUpAnimation = true
        }
    }

    func isPlayable(grid: [[Coin]]) -> Bool {
        for row in 0..<grid.count {
            for column in 0..<grid[row].count {
                let currentValue = grid[row][column].value

                // Check adjacent cells for possible matches
                let adjacentPositions = [
                    (row - 1, column), // Above
                    (row + 1, column), // Below
                    (row, column - 1), // Left
                    (row, column + 1)  // Right
                ]

                for (adjRow, adjColumn) in adjacentPositions {
                    if adjRow >= 0, adjRow < grid.count, adjColumn >= 0, adjColumn < grid[row].count {
                        if grid[adjRow][adjColumn].value == currentValue {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    func playSystemSound(success: Bool) {
        let soundID: SystemSoundID = success ? 1104 : 1053
        AudioServicesPlaySystemSound(soundID)
    }

    func playLevelUpSound() {
        AudioServicesPlaySystemSound(1025)
    }

    func resetGame() {
        grid = generateGrid(rows: 6, columns: 6)
        previewCoins = generatePreviewCoins(count: 6) // Reset preview line
        score = 0
        level = 1
        targetScore = 5000
        selectedCoins.removeAll()
    }
}

// Helper to generate preview coins
func generatePreviewCoins(count: Int) -> [Coin] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<count).map { _ in Coin(value: coinValues.randomElement()!) }
}

func generateCoin() -> Coin {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return Coin(value: coinValues.randomElement()!)
}

func nextCoinValue(for value: Int) -> Int {
    switch value {
    case 1: return 5
    case 5: return 10
    case 10: return 50
    case 50: return 100
    case 100: return 500
    case 500: return 1000
    default: return 0
    }
}

func generateGrid(rows: Int, columns: Int) -> [[Coin]] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    var grid: [[Coin]] = []

    for _ in 0..<rows {
        var row: [Coin] = []
        for _ in 0..<columns {
            let randomValue = coinValues.randomElement()!
            row.append(Coin(value: randomValue))
        }
        grid.append(row)
    }

    return grid
}


struct TileMatchingGameView_Previews: PreviewProvider {
    static var previews: some View {
        TileMatchingGameView()
    }
}
