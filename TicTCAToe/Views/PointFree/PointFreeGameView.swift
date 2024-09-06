// Minimally modified version of: https://github.com/pointfreeco/swift-composable-architecture/tree/main/Examples/TicTacToe
import ComposableArchitecture
import SwiftUI

// MARK: - Game

@Reducer
public struct PointFreeGame: Sendable {
    @Dependency(\.dismiss) var dismiss
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .cellTapped(row, column):
                guard state.board[row][column] == nil, !state.board.hasWinner else { return .none }
                state.board[row][column] = state.currentPlayer
                if !state.board.hasWinner {
                    state.currentPlayer.toggle()
                }
                return .none
            case .playAgainButtonTapped:
                state = PointFreeGame.State()
                return .none
            }
        }
    }
}

// MARK: - Player

public enum PointFreePlayer: Equatable, Sendable {
    case o
    case x
    
    public var label: String {
        switch self {
        case .o: "⭕️"
        case .x: "❌"
        }
    }
    
    public mutating func toggle() {
        switch self {
        case .o: self = .x
        case .x: self = .o
        }
    }
}

extension PointFreeGame {
    public enum Action: Sendable {
        case cellTapped(row: Int, column: Int)
        case playAgainButtonTapped
    }
}

extension PointFreeGame {
    @ObservableState
    public struct State: Equatable {
        public var board: PointFreeThree<PointFreeThree<PointFreePlayer?>> = .empty
        public var currentPlayer: PointFreePlayer = .x
    }
}

// MARK: - Board

public struct PointFreeThree<Element> {
    public var first: Element
    public var second: Element
    public var third: Element
    
    public init(_ first: Element, _ second: Element, _ third: Element) {
        self.first = first
        self.second = second
        self.third = third
    }
    
    public func map<T>(_ transform: (Element) -> T) -> PointFreeThree<T> {
        .init(transform(self.first), transform(self.second), transform(self.third))
    }
}

extension PointFreeThree: MutableCollection {
    public subscript(offset: Int) -> Element {
        _read {
            switch offset {
            case 0: yield self.first
            case 1: yield self.second
            case 2: yield self.third
            default: fatalError()
            }
        }
        _modify {
            switch offset {
            case 0: yield &self.first
            case 1: yield &self.second
            case 2: yield &self.third
            default: fatalError()
            }
        }
    }
    
    public var startIndex: Int { 0 }
    public var endIndex: Int { 3 }
    public func index(after i: Int) -> Int { i + 1 }
}

extension PointFreeThree: RandomAccessCollection {}

extension PointFreeThree: Equatable where Element: Equatable {}

extension PointFreeThree: Hashable where Element: Hashable {}

extension PointFreeThree: Sendable where Element: Sendable {}

extension PointFreeThree<PointFreeThree<PointFreePlayer?>> {
    public static let empty = Self(
        .init(nil, nil, nil),
        .init(nil, nil, nil),
        .init(nil, nil, nil)
    )
    
    public var isFilled: Bool {
        self.allSatisfy { $0.allSatisfy { $0 != nil } }
    }
    
    func hasWin(_ PFPlayer: PointFreePlayer) -> Bool {
        let winConditions = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8],
            [0, 3, 6], [1, 4, 7], [2, 5, 8],
            [0, 4, 8], [6, 4, 2],
        ]
        for condition in winConditions {
            let matches = condition.map { self[$0 % 3][$0 / 3] }
            let matchCount = matches.filter { $0 == PFPlayer }.count
            if matchCount == 3 {
                return true
            }
        }
        return false
    }
    
    public var hasWinner: Bool {
        hasWin(.x) || hasWin(.o)
    }
}

// MARK: - View

@MainActor
public struct PointFreeGameView: View {
    let store: StoreOf<PointFreeGame>
    
    public init(store: StoreOf<PointFreeGame>) {
        self.store = store
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0.0) {
                VStack {
                    Text(store.title)
                        .font(.title)
                    if store.isPlayAgainButtonVisible {
                        Button("Play again?") {
                            store.send(.playAgainButtonTapped)
                        }
                        .padding(.top, 12)
                        .font(.title)
                    }
                }
                .padding(.bottom, 48)
                VStack {
                    rowView(row: 0, proxy: proxy)
                    rowView(row: 1, proxy: proxy)
                    rowView(row: 2, proxy: proxy)
                }
                .disabled(store.isGameDisabled)
            }
            .navigationTitle("Tic-tac-toe")
            .navigationBarBackButtonHidden(true)
        }
    }
    
    func rowView(row: Int, proxy: GeometryProxy) -> some View {
        HStack(spacing: 0.0) {
            cellView(row: row, column: 0, proxy: proxy)
            cellView(row: row, column: 1, proxy: proxy)
            cellView(row: row, column: 2, proxy: proxy)
        }
    }
    
    func cellView(row: Int, column: Int, proxy: GeometryProxy) -> some View {
        Button {
            store.send(.cellTapped(row: row, column: column))
        } label: {
            Text(store.rows[row][column])
                .frame(width: proxy.size.width / 3, height: proxy.size.width / 3)
                .background(
                    (row + column).isMultiple(of: 2)
                    ? Color(red: 0.8, green: 0.8, blue: 0.8)
                    : Color(red: 0.6, green: 0.6, blue: 0.6)
                )
        }
    }
}

extension PointFreeGame.State {
    fileprivate var rows: [[String]] {
        self.board.map { $0.map { $0?.label ?? "" } }
    }
    
    fileprivate var isGameDisabled: Bool {
        self.board.hasWinner || self.board.isFilled
    }
    
    fileprivate var isPlayAgainButtonVisible: Bool {
        self.board.hasWinner || self.board.isFilled
    }
    
    fileprivate var title: String {
        self.board.hasWinner
        ? "Winner! Congrats \(self.currentPlayer.label)!"
        : self.board.isFilled
        ? "Tied game!"
        : "Current player: \(self.currentPlayer.label)"
    }
}

#Preview {
    PointFreeGameView(
        store: Store(initialState: PointFreeGame.State()) {
            PointFreeGame()
        }
    )
}
