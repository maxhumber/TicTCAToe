import Foundation

enum Player: String {
    case x = "❌"
    case o = "⭕️"

    mutating func toggle() {
        switch self {
        case .o: self = .x
        case .x: self = .o
        }
    }
}
