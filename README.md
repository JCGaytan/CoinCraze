
# Tile Matching Game Documentation

## Overview (EN)

### Project Idea
The Tile Matching Game is a SwiftUI-based interactive puzzle game. Players merge coins of the same value to increase their value. The goal is to reach a target score to progress through levels, with the grid and preview coins resetting upon each new level.
<img src="https://github.com/JCGaytan/CoinCraze/blob/main/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-01-01%20at%2016.53.58.png" alt="CoinCraze" style="width:300px;"/>
This game leverages the flexibility of **SwiftUI**, which allows developers to create interactive UIs declaratively. SwiftUI handles state management, animations, and layout dynamically, making it an ideal framework for building games with real-time interaction and feedback.

### Key Features
- **Dynamic Grid**: A 6x6 grid of coins with randomly generated values.
- **Preview Coins**: A preview line to indicate upcoming coins.
- **Level Progression**: Scores reset on leveling up with a higher target.
- **Automatic Reshuffle**: Ensures at least one valid move exists.

### How SwiftUI Works
SwiftUI provides declarative syntax to define UI components. In this app:
- State variables (`@State`) are used to manage dynamic elements like the grid, preview coins, and score.
- `LazyVGrid` and `LazyHGrid` efficiently render the coin grid and preview line.
- Animations and gestures are seamlessly integrated for user feedback.

### Code References

#### **Grid Management**
The grid is a 2D array of `Coin` structs:
```swift
@State private var grid: [[Coin]] = generateGrid(rows: 6, columns: 6)

func generateGrid(rows: Int, columns: Int) -> [[Coin]] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<rows).map { _ in
        (0..<columns).map { _ in Coin(value: coinValues.randomElement()!) }
    }
}
```

#### **Preview Coins**
Preview coins provide visibility into upcoming drops:
```swift
@State private var previewCoins: [Coin] = generatePreviewCoins(count: 6)

func generatePreviewCoins(count: Int) -> [Coin] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<count).map { _ in Coin(value: coinValues.randomElement()!) }
}
```

#### **Gameplay Logic**
Dragging and merging coins:
```swift
func handleDrag(at location: CGPoint, cellSize: CGFloat, spacing: CGFloat) {
    let column = Int(location.x / (cellSize + spacing))
    let row = Int(location.y / (cellSize + spacing))
    // Check for adjacency and same value logic...
}
```

---

## Resumen (ES)

### Idea del Proyecto
El Juego de Coincidencia de Fichas es un juego interactivo basado en SwiftUI. Los jugadores combinan monedas del mismo valor para aumentar su valor. El objetivo es alcanzar una puntuación objetivo para avanzar de nivel, reiniciando la cuadrícula y las monedas de vista previa en cada nivel nuevo.
<img src="https://github.com/JCGaytan/CoinCraze/blob/main/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-01-01%20at%2016.53.58.png" alt="CoinCraze" style="width:300px;"/>
Este juego aprovecha la flexibilidad de **SwiftUI**, que permite a los desarrolladores crear interfaces interactivas de forma declarativa. SwiftUI maneja la gestión de estados, animaciones y diseño dinámico, lo que lo convierte en un marco ideal para crear juegos con interacción en tiempo real.

### Características Clave
- **Cuadrícula Dinámica**: Una cuadrícula de 6x6 con valores generados aleatoriamente.
- **Monedas de Vista Previa**: Una línea de vista previa para indicar las próximas monedas.
- **Progresión de Nivel**: Las puntuaciones se reinician al subir de nivel con un objetivo más alto.
- **Reorganización Automática**: Garantiza al menos un movimiento válido.

### Cómo Funciona SwiftUI
SwiftUI proporciona una sintaxis declarativa para definir componentes de la interfaz. En esta aplicación:
- Las variables de estado (`@State`) se utilizan para gestionar elementos dinámicos como la cuadrícula, las monedas de vista previa y la puntuación.
- `LazyVGrid` y `LazyHGrid` renderizan eficientemente la cuadrícula y la línea de vista previa.
- Las animaciones y gestos se integran de forma sencilla para la retroalimentación del usuario.

### Referencias del Código

#### **Gestión de la Cuadrícula**
La cuadrícula es un array 2D de estructuras `Coin`:
```swift
@State private var grid: [[Coin]] = generateGrid(rows: 6, columns: 6)

func generateGrid(rows: Int, columns: Int) -> [[Coin]] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<rows).map { _ in
        (0..<columns).map { _ in Coin(value: coinValues.randomElement()!) }
    }
}
```

#### **Monedas de Vista Previa**
Las monedas de vista previa brindan visibilidad sobre las próximas caídas:
```swift
@State private var previewCoins: [Coin] = generatePreviewCoins(count: 6)

func generatePreviewCoins(count: Int) -> [Coin] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<count).map { _ in Coin(value: coinValues.randomElement()!) }
}
```

#### **Lógica del Juego**
Arrastrar y combinar monedas:
```swift
func handleDrag(at location: CGPoint, cellSize: CGFloat, spacing: CGFloat) {
    let column = Int(location.x / (cellSize + spacing))
    let row = Int(location.y / (cellSize + spacing))
    // Comprobación de adyacencia y lógica de valores iguales...
}
```

---

## Vue d'ensemble (FR)

### Idée du Projet
Le Jeu de Correspondance de Tuiles est un jeu interactif basé sur SwiftUI. Les joueurs fusionnent des pièces ayant la même valeur pour augmenter leur valeur. L'objectif est d'atteindre un score cible pour progresser dans les niveaux, en réinitialisant la grille et les pièces de prévisualisation à chaque nouveau niveau.
<img src="https://github.com/JCGaytan/CoinCraze/blob/main/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202025-01-01%20at%2016.53.58.png" alt="CoinCraze" style="width:300px;"/>
Ce jeu tire parti de la flexibilité de **SwiftUI**, qui permet aux développeurs de créer des interfaces interactives de manière déclarative. SwiftUI gère la gestion des états, les animations et la disposition de manière dynamique, ce qui en fait un cadre idéal pour créer des jeux avec une interaction en temps réel.

### Principales Caractéristiques
- **Grille Dynamique** : Une grille 6x6 avec des valeurs générées aléatoirement.
- **Pièces de Prévisualisation** : Une ligne de prévisualisation pour indiquer les prochaines pièces.
- **Progression de Niveau** : Les scores sont réinitialisés à chaque montée de niveau avec un objectif plus élevé.
- **Remélange Automatique** : Garantit au moins un mouvement valide.

### Comment Fonctionne SwiftUI
SwiftUI fournit une syntaxe déclarative pour définir les composants de l'interface utilisateur. Dans cette application :
- Les variables d'état (`@State`) gèrent des éléments dynamiques comme la grille, les pièces de prévisualisation et le score.
- `LazyVGrid` et `LazyHGrid` rendent efficacement la grille et la ligne de prévisualisation.
- Les animations et les gestes sont intégrés de manière transparente pour un retour utilisateur.

### Références du Code

#### **Gestion de la Grille**
La grille est un tableau 2D de structures `Coin` :
```swift
@State private var grid: [[Coin]] = generateGrid(rows: 6, columns: 6)

func generateGrid(rows: Int, columns: Int) -> [[Coin]] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<rows).map { _ in
        (0..<columns).map { _ in Coin(value: coinValues.randomElement()!) }
    }
}
```

#### **Pièces de Prévisualisation**
Les pièces de prévisualisation montrent les prochaines pièces à tomber :
```swift
@State private var previewCoins: [Coin] = generatePreviewCoins(count: 6)

func generatePreviewCoins(count: Int) -> [Coin] {
    let coinValues = [1, 5, 10, 50, 100, 500]
    return (0..<count).map { _ in Coin(value: coinValues.randomElement()!) }
}
```

#### **Logique du Jeu**
Glisser et fusionner les pièces :
```swift
func handleDrag(at location: CGPoint, cellSize: CGFloat, spacing: CGFloat) {
    let column = Int(location.x / (cellSize + spacing))
    let row = Int(location.y / (cellSize + spacing))
    // Vérification de l'adjacence et logique des valeurs similaires...
}
```
