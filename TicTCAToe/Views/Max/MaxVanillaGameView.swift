import SwiftUI

struct MaxVanillaGame {
    var currentPlayer: Player = .x
    var board: Board = .empty
    
    var isDisabled: Bool {
        board.hasWinner || board.isFilled
    }
    
    var status: String {
        switch true {
        case board.isFilled: "Tie Game"
        case board.hasWinner: "Winner: \(currentPlayer.rawValue)"
        default: "Current Player: \(currentPlayer.rawValue)"
        }
    }

    mutating func tapCell(row: Int, col: Int) {
        guard board[row][col] == nil, !board.hasWinner else { return }
        board[row][col] = currentPlayer
        if !board.hasWinner {
            currentPlayer.toggle()
        }
    }
    
    mutating func reset() {
        currentPlayer = .x
        board = .empty
    }
}

struct MaxVanillaGameView: View {
    @State private var game = MaxVanillaGame()
    
    var body: some View {
        VStack(spacing: 10) {
            Text(game.status)
            GameBoardComponent(board: game.board) { row, col in
                game.tapCell(row: row, col: col)
            }
            .disabled(game.isDisabled)
            Button("Play Again") {
                game.reset()
            }
            .opacity(game.isDisabled ? 1 : 0)
        }
        .padding()
    }
}

#Preview {
    MaxVanillaGameView()
}
