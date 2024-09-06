import SwiftUI

struct GameBoardComponent: View {
    let board: Board
    let action: (_ row: Int, _ col: Int) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { col in
                        cell(row: row, col: col)
                    }
                }
            }
        }
    }
    
    private func cell(row: Int, col: Int) -> some View {
        Text(board[row][col]?.rawValue ?? "")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(Color.gray.opacity((row + col).isMultiple(of: 2) ? 0.3 : 0.6))
            .onTapGesture { action(row, col) }
    }
}

#Preview {
    GameBoardComponent(board: .empty, action: { _, _ in })
}
