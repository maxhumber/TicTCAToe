import Testing
@testable import TicTCAToe

struct MaxVanillaGameTests {
    @Test
    func testXWin() async throws {
        var game = MaxVanillaGame()
        #expect(game.currentPlayer == .x)
        game.tapCell(row: 0, col: 0) // x
        game.tapCell(row: 2, col: 1) // o
        game.tapCell(row: 1, col: 0) // x
        game.tapCell(row: 1, col: 1) // o
        game.tapCell(row: 2, col: 0) // x
        #expect(game.status == "Winner: ❌")
        #expect(game.board.hasWin(.x) == true)
    }
    
    @Test
    func testTieGame() async throws {
        var game = MaxVanillaGame()
        game.tapCell(row: 0, col: 0) // x
        game.tapCell(row: 2, col: 2) // o
        game.tapCell(row: 1, col: 0) // x
        game.tapCell(row: 2, col: 0) // o
        game.tapCell(row: 2, col: 1) // x
        game.tapCell(row: 1, col: 2) // o
        game.tapCell(row: 0, col: 2) // x
        game.tapCell(row: 0, col: 1) // o
        game.tapCell(row: 1, col: 1) // x
        #expect(game.board.isFilled && !game.board.hasWinner)
    }
}
