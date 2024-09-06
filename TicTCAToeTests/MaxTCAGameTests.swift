//
//  MaxTCAGameTests.swift
//  TicTCAToeTests
//
//  Created by Max Humber on 2024-09-05.
//

import XCTest
import ComposableArchitecture
@testable import TicTCAToe

final class GameCoreTests: XCTestCase {
    func testFlow_Winner_Quit() async {
        let store = await TestStore(
            initialState: MaxTCAGame.State()
        ) {
            MaxTCAGame()
        }
        await store.send(.cellTapped(row: 0, col: 0)) {
            $0.board[0][0] = .x
            $0.currentPlayer = .o
        }
        await store.send(.cellTapped(row: 2, col: 1)) {
            $0.board[2][1] = .o
            $0.currentPlayer = .x
        }
        await store.send(.cellTapped(row: 1, col: 0)) {
            $0.board[1][0] = .x
            $0.currentPlayer = .o
        }
        await store.send(.cellTapped(row: 1, col: 1)) {
            $0.board[1][1] = .o
            $0.currentPlayer = .x
        }
        await store.send(.cellTapped(row: 2, col: 0)) {
            $0.board[2][0] = .x
        }
    }
    
    func testFlow_Tie() async {
        let store = await TestStore(
            initialState: MaxTCAGame.State()
        ) {
            MaxTCAGame()
        }
        await store.send(.cellTapped(row: 0, col: 0)) {
            $0.board[0][0] = .x
            $0.currentPlayer = .o
        }
        await store.send(.cellTapped(row: 2, col: 2)) {
            $0.board[2][2] = .o
            $0.currentPlayer = .x
        }
        await store.send(.cellTapped(row: 1, col: 0)) {
            $0.board[1][0] = .x
            $0.currentPlayer = .o
        }
        await store.send(.cellTapped(row: 2, col: 0)) {
            $0.board[2][0] = .o
            $0.currentPlayer = .x
        }
        await store.send(.cellTapped(row: 2, col: 1)) {
            $0.board[2][1] = .x
            $0.currentPlayer = .o
        }
        await store.send(.cellTapped(row: 1, col: 2)) {
            $0.board[1][2] = .o
            $0.currentPlayer = .x
        }
        await store.send(.cellTapped(row: 0, col: 2)) {
            $0.board[0][2] = .x
            $0.currentPlayer = .o
        }
        await store.send(.cellTapped(row: 0, col: 1)) {
            $0.board[0][1] = .o
            $0.currentPlayer = .x
        }
        await store.send(.cellTapped(row: 1, col: 1)) {
            $0.board[1][1] = .x
            $0.currentPlayer = .o
        }
        await store.send(.playAgainButtonTapped) {
            $0 = MaxTCAGame.State()
        }
    }
}
