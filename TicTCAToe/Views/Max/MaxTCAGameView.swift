import ComposableArchitecture
import SwiftUI

@Reducer
struct MaxTCAGame: Sendable {
    @ObservableState
    struct State: Equatable {
        var currentPlayer: Player = .x
        var board: Board = .empty
    }
    
    enum Action: Sendable {
        case cellTapped(row: Int, col: Int)
        case playAgainButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .cellTapped(row, col):
                guard state.board[row][col] == nil, !state.board.hasWinner else { return .none }
                state.board[row][col] = state.currentPlayer
                if !state.board.hasWinner {
                    state.currentPlayer.toggle()
                }
                return .none
            case .playAgainButtonTapped:
                state = MaxTCAGame.State()
                return .none
            }
        }
    }
}

extension MaxTCAGame.State {
    var isGameDisabled: Bool {
        board.hasWinner || board.isFilled
    }
    
    var status: String {
        switch true {
        case board.isFilled: "Tie Game"
        case board.hasWinner: "Winner: \(currentPlayer.rawValue)"
        default: "Current Player: \(currentPlayer.rawValue)"
        }
    }
}

struct MaxTCAGameView: View {
    let store: StoreOf<MaxTCAGame>
    
    var body: some View {
        VStack(spacing: 10) {
            Text(store.state.status)
            GameBoardComponent(board: store.state.board) { row, col in
                store.send(.cellTapped(row: row, col: col))
            }
            .disabled(store.state.isGameDisabled)
            Button("Play Again") {
                store.send(.playAgainButtonTapped)
            }
            .opacity(store.state.isGameDisabled ? 1 : 0)
        }
        .padding()
    }
}

#Preview {
    MaxTCAGameView(store: Store(initialState: MaxTCAGame.State()) {
        MaxTCAGame()
    })
}
