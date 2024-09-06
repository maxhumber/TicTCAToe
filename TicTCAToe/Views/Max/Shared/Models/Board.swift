import Foundation

typealias Board = [[Player?]]

extension Board {
    static var empty: Self {[
        [nil, nil, nil],
        [nil, nil, nil],
        [nil, nil, nil]
    ]}
    
    var isFilled: Bool {
        flatMap({ $0 }).allSatisfy({ $0 != nil })
    }
    
    var hasWinner: Bool {
        hasWin(.x) || hasWin(.o)
    }
    
    func hasWin(_ player: Player) -> Bool {
        let winConditions = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
            [0, 4, 8], [6, 4, 2],            // diagonals
        ]
        for condition in winConditions {
            let cells = condition.map { self[$0 % 3][$0 / 3] }
            if cells.allSatisfy({ $0 == player }) {
                return true
            }
        }
        return false
    }
}
